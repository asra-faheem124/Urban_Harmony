import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/ProductDetail.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/product.dart';
import 'package:laptop_harbor/userPanel/rate_us.dart';
import 'package:laptop_harbor/userPanel/splash.dart';
import 'package:laptop_harbor/userPanel/terms_and_conditions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
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
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/logo2.png', height: 40),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.person_2_outlined),
                title: Text('Profile'),
                // onTap:
                //     () => Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => Profile()),
                //     ),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Orders'),
                // onTap:
                //     () => Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => Orders()),
                //     ),
              ),
              ListTile(
                leading: Icon(Icons.location_on_outlined),
                title: Text('Address'),
                // onTap:
                //     () => Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => Address()),
                //     ),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Rate Us'),
                 onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RateUsPage()),
                    ),
              ),
              Divider(height: 2),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.article_outlined),
                title: Text('Terms & Conditions'),
                onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions()),
                  ),
              ),
              ListTile(
                leading: Icon(Icons.logout_outlined, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                 onTap:
                    (){_auth.signOut();
                    Get.off(Login());
                    }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProductsScreen();
                            },
                          ),
                        );
                      },
                      label: Text(
                        "See more",
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
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
                  ],
                ),
              ),
            ),

//            GridView.count(
//   crossAxisCount: 2,
//   crossAxisSpacing: 12,
//   mainAxisSpacing: 12,
//   padding: EdgeInsets.all(4),
//   childAspectRatio: 0.7, // You can fine-tune this if needed
//   shrinkWrap: true,
//   physics: NeverScrollableScrollPhysics(), // If nested in scroll view
//   children: List.generate(2, (index) {
//     return Card(
//       color: Colors.white,
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Fixed image height
//             SizedBox(
//               height: 100,
//               child: Image.asset(
//                 index == 0
//                     ? "assets/images/laptop3.png"
//                     : "assets/images/laptop1.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "Apple Mac Book Pro i9",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.star, color: Colors.orange, size: 16),
//                 SizedBox(width: 4),
//                 Text("4.5", style: TextStyle(fontSize: 14)),
//               ],
//             ),
//             SizedBox(height: 4),
//             Text(
//               "Mac Book Pro i9, 16GB RAM, 512GB SSD",
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontSize: 13, color: Colors.grey[700]),
//             ),
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "PKR 2,29,350",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) {
//                         return ProductDetail();
//                       }),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   ),
//                   child: Text("Details", style: TextStyle(fontSize: 12)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }),
// ),

          ],
        ),
      ),
    );
  }
}

