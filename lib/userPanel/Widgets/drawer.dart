import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_category.dart';
import 'package:laptop_harbor/Admin/add_product.dart';
import 'package:laptop_harbor/Admin/admin_feedback.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/Admin/admin_ratings.dart';
import 'package:laptop_harbor/Admin/admin_users.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/userPanel/contact_feedback.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/logout.dart';
import 'package:laptop_harbor/userPanel/rate_us.dart';
import 'package:laptop_harbor/userPanel/terms_and_conditions.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final Getuserdatacontroller getuserdatacontroller = Get.put(Getuserdatacontroller());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If user is not logged in
    if (user == null) {
      return Drawer(
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
                leading: Icon(Icons.app_registration_rounded),
                title: Text('Signup'),
                onTap: () => Get.to(Login()),
              ),
              ListTile(
                leading: Icon(Icons.article_outlined),
                title: Text('Terms & Conditions'),
                onTap: () => Get.to(TermsAndConditions()),
              ),
            ],
          ),
        ),
      );
    }

    // If user is logged in
    final uid = user.uid;

    return Drawer(
      child: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getuserdatacontroller.getuserdata(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Icon(Icons.error));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Data Not Found!'));
          }

          final doc = snapshot.data!.first;
          final data = doc.data() as Map<String, dynamic>;
          final isAdmin = data['isAdmin'] == true;

          return Drawer(
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
                  if (isAdmin) ...[
                    ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Get.offAll(AdminHomeScreen()),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users'),
            onTap: () {Get.to(AdminUsersPage());}, 
          ),
           ListTile(
            leading: Icon(Icons.category_rounded),
            title: Text('Catgories'),
            onTap: () {Get.to(AddCategoryPage());}, 
          ),
          ListTile(
            leading: Icon(Icons.laptop),
            title: Text('Products'),
            onTap: () {Get.to(AddProduct());},
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Orders'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Ratings'),
            onTap: () {Get.to(AdminRatingsPage());},
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {Get.to(AdminFeedbackPage());},
          ),
                  ] else ...[
                    ListTile(
                      leading: Icon(Icons.list),
                      title: Text('Orders'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: Text('Address'),
                    ),
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Rate Us'),
                      onTap: () => Get.to(RateUsPage()),
                    ),
                     ListTile(
                      leading: Icon(Icons.contact_support_outlined),
                      title: Text('Contact & Feedback'),
                      onTap: () => Get.to(ContactFeedbackPage()),
                    ),
                    ListTile(
                      leading: Icon(Icons.article_outlined),
                      title: Text('Terms & Conditions'),
                      onTap: () => Get.to(TermsAndConditions()),
                    ),
                  ],
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout_outlined, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                     Get.to(LogoutScreen());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
