import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terms and Conditions',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
              const SizedBox(height: 12),
              const Text(
                'Welcome to UrbanHarmony! These Terms and Conditions outline the rules and regulations for using our mobile application.\nBy accessing or using the app, you agree to be bound by these terms. If you disagree with any part of the terms, please do not use our services.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 1
              const Text(
                '1. Use of the App',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'You must be at least 13 years old to use the UrbanHarmony app. You agree to use the app only for lawful purposes and in accordance with these Terms.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 2
              const Text(
                '2. User Accounts',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'a. You are responsible for maintaining the confidentiality of your account and password.\n'
                'b. You agree to provide accurate and complete information when creating an account.\n'
                'c. UrbanHarmony reserves the right to suspend or terminate accounts that contain false information or violate our terms.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 3
              const Text(
                '3. Product & Service Information',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'We aim to provide accurate and up-to-date details about our furniture, décor items, and services. '
                'However, we do not guarantee that all information is free from errors or omissions.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 4
              const Text(
                '4. Orders and Payments',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'a. By placing an order, you agree to pay the listed price and any applicable taxes or delivery charges.\n'
                'b. Orders are subject to availability and confirmation.\n'
                'c. We reserve the right to cancel or refuse orders at our discretion.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 5
              const Text(
                '5. User Reviews',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'a. Users may post reviews and ratings of products or services.\n'
                'b. Reviews must be respectful and must not contain offensive, misleading, or unlawful content.\n'
                'c. UrbanHarmony has the right to remove or moderate reviews.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 6
              const Text(
                '6. Intellectual Property',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'All content, trademarks, logos, and images in the app are the property of UrbanHarmony or its partners. '
                'You may not copy, modify, distribute, or use any content without written permission.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 7
              const Text(
                '7. Changes to Terms',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'UrbanHarmony may update these Terms and Conditions from time to time. '
                'Changes will be posted in the app, and continued use of the app after such changes means you agree to the updated terms.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
