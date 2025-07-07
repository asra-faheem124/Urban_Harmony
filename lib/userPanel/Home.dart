import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/ProductDetail.dart';
import 'package:laptop_harbor/userPanel/Widgets/drawer.dart';
import 'package:laptop_harbor/userPanel/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    // Open the right-side drawer
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 450,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 7.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Try Search here...",

                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
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
                        "Categories",
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.06, // around 24 on 400px screen
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromARGB(
                          255,
                          202,
                          201,
                          201,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.apple,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Apple', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromARGB(
                          255,
                          202,
                          201,
                          201,
                        ),
                        child: Image.asset(
                          'assets/images/dell.png',
                          height: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Dell', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromARGB(
                          255,
                          202,
                          201,
                          201,
                        ),
                        child: Image.asset(
                          'assets/images/hp.png',
                          height: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Hp', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromARGB(
                          255,
                          202,
                          201,
                          201,
                        ),
                        child: Image.asset(
                          'assets/images/lenovo.png',
                          height: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Lenovo', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
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
                              screenWidth * 0.06, // around 24 on 400px screen
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
                          fontSize: screenWidth * 0.04, // around 14–16
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_forward,
                        size: screenWidth * 0.05, // around 20
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: EdgeInsets.all(8),

              childAspectRatio: 0.7, // Adjust item height
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Use this if nested in scroll view
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/laptop1.png",
                          // fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apple MacBook Pro Core i9 9th Generation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                Text("4.5", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "16GB RAM, 1TB SSD, Touch Bar, macOS",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "PKR 2,29,300",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetail();
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                  ),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Image.asset("assets/images/laptop2.png")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apple MacBook Pro Core i9 9th Generation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                Text("4.5", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Scenic mountain views and winter adventure.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "PKR 2,290,300",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProductDetail();
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                  ),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
