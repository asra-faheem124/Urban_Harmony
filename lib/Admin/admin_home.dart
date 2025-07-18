import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/Widgets/drawer.dart';
import 'dart:developer';

import 'package:laptop_harbor/userPanel/constant.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int totalUsers = 0;
  int totalCategories = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  int totalRatings = 0;
  int totalContact = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final usersSnap = await FirebaseFirestore.instance.collection('User').get();
      final catSnap = await FirebaseFirestore.instance.collection('category').get();
      final productSnap = await FirebaseFirestore.instance.collection('products').get();
      final orderSnap = await FirebaseFirestore.instance.collection('orders').get();
      final ratingSnap = await FirebaseFirestore.instance.collection('ratings').get();
      final contactSnap = await FirebaseFirestore.instance.collection('contactMessages').get();

      setState(() {
        totalUsers = usersSnap.size;
        totalCategories = catSnap.size;
        totalProducts = productSnap.size;
        totalOrders = orderSnap.size;
        totalRatings = ratingSnap.size;
        totalContact = contactSnap.size;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching admin data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildTile(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
         title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            width: 100,
            child: Image.asset('assets/images/logo2.png'),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.menu, color: Colors.black),
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: DrawerWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Admin_Heading(title: 'Admin Dashboard'),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.4,
                    children: [
                      buildTile('Total Users', totalUsers.toString(),
                          Icons.person, Colors.teal),
                      buildTile('Categories', totalCategories.toString(),
                          Icons.category, Colors.blue),
                      buildTile('Products', totalProducts.toString(),
                          Icons.laptop_mac, Colors.deepOrange),
                      buildTile('Orders', totalOrders.toString(),
                          Icons.receipt_long, Colors.green),
                      buildTile('Ratings', totalRatings.toString(),
                          Icons.star, Colors.amber),
                     buildTile('Contact Messages', totalContact.toString(),
                          Icons.message_rounded, Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
