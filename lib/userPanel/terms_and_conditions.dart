import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms And Conditions',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
              SizedBox(height: 12),
              Text(
                'Welcome to LaptopHarbor! These Terms and Conditions outline the rules and regulations for using our mobile application.\nBy accessing or using the app, you agree to be bound by these terms. If you disagree with any part of the terms, please do not use our services.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '1. Use of the App',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'You must be at least 13 years old to use the LaptopHarbor app. You agree to use the app only for lawful purposes and in accordance with these Terms.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 12),
              Text(
                '2. User Accounts',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'a. You are responsible for maintaining the confidentiality of your account and password.\nb. You agree to provide accurate and complete information when creating an account.\nc. LaptopHarbor reserves the right to suspend or terminate accounts that contain false information or violate our terms.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 12),
              Text(
                '3. Product Information',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'We aim to provide accurate and up-to-date product details, including specifications, pricing, and availability.\nHowever, we do not guarantee that all information is free from errors or omissions.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 12),
              Text(
                '4. Orders and Payments',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'a. By placing an order, you agree to pay the listed price and any applicable taxes or shipping charges.\nb. Orders are subject to availability and confirmation.\nc. We reserve the right to cancel or refuse orders at our discretion',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 12),
              Text(
                '5. User Reviews',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'a. Users may post reviews and ratings of products.\nb. Reviews must be respectful and must not contain offensive, misleading, or unlawful content.\nc. LaptopHarbor has the right to remove or moderate reviews.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 12),
              Text(
                '6. Intellectual Property',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'All content, trademarks, logos, and images in the app are the property of LaptopHarbor or its partners. You may not copy, modify, distribute, or use any content without written permission.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 12),
              Text(
                '7. Changes to Terms',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                'LaptopHarbor may update these Terms and Conditions from time to time. Changes will be posted in the app, and continued use of the app after such changes means you agree to the updated terms.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
