import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/product.dart';
import 'package:laptop_harbor/userPanel/splash.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
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
     endDrawer:  Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/logo2.png',
                    height: 40,
                  ),
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.person_2_outlined),
                  title: Text('Profile',),
                  // onTap:
                  //     () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Profile()),
                  //     ),
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Orders', ),
                  // onTap:
                  //     () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Orders()),
                  //     ),
                ),
                ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Address',),
                  // onTap:
                  //     () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Address()),
                  //     ),
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Rate Us', ),
                  //  onTap:
                  //     () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Wallet()),
                  //     ),
                ),
                Divider(height: 2),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.article_outlined),
                  title: Text('Terms & Conditions', ),
                    // onTap:
                    //   () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => TermsAndConditions()),
                    //   ),
                ),
                ListTile(
                  leading: Icon(Icons.logout_outlined, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red),),
                  //  onTap:
                  //     () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Logout()),
                  //     ),
                ),
              ],
            ),
          ),
        ),
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
              padding: const EdgeInsets.all(26.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(iconColor: Colors.black),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ProductsScreen();
                        }));
                      },
                      label: Text(
                        "See more",
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ]
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color.fromARGB(255, 202, 201, 201),
                                child: FaIcon(FontAwesomeIcons.apple, color: Colors.black, size: 40,),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text('Apple', style: TextStyle(fontSize: 16),)
                          ],
                        ),
                         Column(
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color.fromARGB(255, 202, 201, 201),
                                child: Image.asset('assets/images/dell.png', height: 40, color: Colors.black,),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text('Dell', style: TextStyle(fontSize: 16),)
                          ],
                        ),
                         Column(
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color.fromARGB(255, 202, 201, 201),
                                child:Image.asset('assets/images/hp.png', height: 40, color: Colors.black,),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text('Hp', style: TextStyle(fontSize: 16),)
                          ],
                        ),
                         Column(
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color.fromARGB(255, 202, 201, 201),
                                child:Image.asset('assets/images/lenovo.png', height: 50, color: Colors.black,),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text('Lenovo', style: TextStyle(fontSize: 16),)
                          ],
                        )
                      ],
                    ),
                     SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Featured Laptops",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(iconColor: Colors.black),
                      onPressed: () {},
                      label: Text(
                        "See more",
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
