import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/Admin/admin_category.dart';
import 'package:laptop_harbor/Admin/admin_design.dart';
import 'package:laptop_harbor/Admin/admin_design_category.dart';
import 'package:laptop_harbor/Admin/admin_feedback.dart';
import 'package:laptop_harbor/Admin/admin_orders.dart';
import 'package:laptop_harbor/Admin/admin_products.dart';
import 'package:laptop_harbor/Admin/admin_ratings.dart';
import 'package:laptop_harbor/Admin/admin_users.dart';
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
  int totalDesignCategories = 0;
  int totalProducts = 0;
  int totalDesign = 0;
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
      final usersSnap =
          await FirebaseFirestore.instance.collection('User').get();
      final catSnap =
          await FirebaseFirestore.instance.collection('category').get();
          final deCatSnap =
          await FirebaseFirestore.instance.collection('designCategories').get();
      final productSnap =
          await FirebaseFirestore.instance.collection('products').get();
          final designSnap =
          await FirebaseFirestore.instance.collection('design').get();
      final orderSnap =
          await FirebaseFirestore.instance.collection('orders').get();
      final ratingSnap =
          await FirebaseFirestore.instance.collection('ratings').get();
      final contactSnap =
          await FirebaseFirestore.instance.collection('contactMessages').get();

      setState(() {
        totalUsers = usersSnap.size;
        totalCategories = catSnap.size;
        totalDesignCategories = deCatSnap.size;
        totalProducts = productSnap.size;
        totalDesign = designSnap.size;
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

  Widget buildTile(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, color: color, size: 32),
          ],
        ),
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
            child: Image.asset('assets/images/Logo1.png'),
          ),
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Admin_Heading(title: 'Admin Dashboard'),
                    const SizedBox(height: 20),

                    buildTile(
                      'Total Users',
                      totalUsers.toString(),
                      Icons.person,
                      Colors.teal,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminUsersPage()),
                      ),
                    ),

                    buildTile(
                      'Categories',
                      totalCategories.toString(),
                      Icons.category,
                      Colors.blue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminCategoryPage()),
                      ),
                    ),

                     buildTile(
                      'Design Categories',
                      totalCategories.toString(),
                      Icons.category,
                      Colors.blue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdminDesignCategoryPage()),
                      ),
                    ),

                    buildTile(
                      'Products',
                      totalProducts.toString(),
                      Icons.laptop_mac,
                      Colors.deepOrange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminProductsPage(),
                          ),
                        ),
                        ),
                         buildTile(
                      'Design',
                      totalProducts.toString(),
                      Icons.bed,
                      Colors.deepOrange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminDesignPage(),
                          ),
                        ),
                        ),

                    buildTile(
                      'Orders',
                      totalOrders.toString(),
                      Icons.receipt_long,
                      Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminOrdersPage()),
                        ),
                    ),

                    buildTile(
                      'Ratings',
                      totalRatings.toString(),
                      Icons.star,
                      Colors.amber,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminRatingsPage()),
                        ),
                    ),

                    buildTile(
                      'Contact Messages',
                      totalContact.toString(),
                      Icons.message_rounded,
                      Colors.purple,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminFeedbackPage(),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
    );
  }
}
