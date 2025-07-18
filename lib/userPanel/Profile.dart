import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/EditProfile.dart';
import 'package:laptop_harbor/userPanel/about-app.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
import 'package:laptop_harbor/userPanel/help_and_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/userPanel/logout.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Get current user's UID
  final String uid = FirebaseAuth.instance.currentUser!.uid;
      final currentUser = FirebaseAuth.instance.currentUser;


  // Function to fetch user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    final doc =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User data not found"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               User_Heading(title: 'My Profile'),

                // Profile Card
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // User Image + Info
                        Row(
                          children: [
                            CircleAvatar(
  radius: 40,
  backgroundColor: Colors.grey[300],
  child: Text(
    user['name'] != null && user['name'].toString().isNotEmpty
        ? user['name'][0].toUpperCase()
        : '?',
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
),
                            const SizedBox(width: 12),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${user['name']}\n",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      height: 1.7,
                                    ),
                                  ),
                                  TextSpan(
                                    text: user['email'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
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
                ), 

            // Spacer between profile and list
            const SizedBox(height: 10),

            // Custom list items
            SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24, // size of the circle
                          backgroundColor:
                              Colors.black, // background circle color
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Your Account",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Make Changes To Your account",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.to(EditProfile());
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24, // size of the circle
                          backgroundColor:
                              Colors.black, // background circle color
                          child: Icon(Icons.logout, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Further Secure Your Account",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.to(LogoutScreen());
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: 25),
              child: Text(
                "More",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24, // size of the circle
                          backgroundColor:
                              Colors.black, // background circle color
                          child: Icon(Icons.help_outline, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Help & Support",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.to(HelpSupportPage());
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24, // size of the circle
                          backgroundColor:
                              Colors.black, // background circle color
                          child: Icon(Icons.favorite, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "About App",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.to(AboutAppPage());
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
          );
        },
      )
  );
  }
}
