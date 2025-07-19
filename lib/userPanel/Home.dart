import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/notificationController';
import 'package:laptop_harbor/userPanel/Profile.dart';
import 'package:laptop_harbor/userPanel/Widgets/animated_text.dart';
import 'package:laptop_harbor/userPanel/Widgets/drawer.dart';
import 'package:laptop_harbor/userPanel/Widgets/products.dart';
import 'package:laptop_harbor/userPanel/Widgets/top_rated_laptops.dart';
import 'package:laptop_harbor/userPanel/notification.dart';
import 'package:laptop_harbor/userPanel/product.dart';
import 'package:laptop_harbor/userPanel/signup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationController notificationController = Get.put(NotificationController());

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<DocumentSnapshot> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return FirebaseFirestore.instance.collection('User').doc(uid).get();
    }
    throw Exception("User not logged in");
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
  
          FutureBuilder<DocumentSnapshot>(
            future: _getUserData(), // call function to fetch user data
            builder: (context, snapshot) {
              final user = FirebaseAuth.instance.currentUser;

              // If user is logged in and data is available
              if (user != null &&
                  snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final name = userData['name'] ?? '';
                final firstLetter =
                    name.isNotEmpty ? name[0].toUpperCase() : '?';

                return Row(
                  children: [
                    Stack(
  children: [
    IconButton(
      icon: const Icon(Icons.notifications_none),
      onPressed: () {
        Get.to(() => NotificationsScreen());
      },
    ),
    Obx(() {
      if (notificationController.unreadCount.value == 0) {
        return SizedBox();
      } else {
        return Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${notificationController.unreadCount.value}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        );
      }
    }),
  ],
),


                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => Get.to(Profile()),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              // If not logged in
              return IconButton(
                icon: Icon(Icons.app_registration_rounded, color: Colors.black),
                onPressed: () {
                  Get.to(SignUp());
                },
              );
            },
          ),
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      endDrawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedHeadline(),
            SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
                viewportFraction: 0.9,
              ),
              items:
                  [
                    'assets/images/slider1.jpg',
                    'assets/images/slider2.jpg',
                    'assets/images/slider3.jpg',
                  ].map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ), // less padding for small screens
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title text with responsive font size
                    Flexible(
                      child: Text(
                        "Featured Laptops",
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.05, // around 24 on 400px screen
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // "See more" button
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        iconColor: Colors.black,
                        padding: const EdgeInsets.only(left: 8),
                      ),
                      onPressed: () {
                        Get.to(ProductsScreen());
                      },
                      label: Text(
                        "See more",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                      icon: Icon(Icons.arrow_forward, size: screenWidth * 0.05),
                    ),
                  ],
                ),
              ),
            ),
            DynamicProducts(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ), // less padding for small screens
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title text with responsive font size
                    Flexible(
                      child: Text(
                        "Top Rated Laptops",
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.05, // around 24 on 400px screen
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TopRatedLaptopsGrid(),
          ],
        ),
      ),
    );
  }
}
