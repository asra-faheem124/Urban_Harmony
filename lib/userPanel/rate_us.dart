import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class RateUsPage extends StatefulWidget {
  final String productId;
  RateUsPage({required this.productId});

  @override
  State<RateUsPage> createState() => _RateUsPageState();
}

class _RateUsPageState extends State<RateUsPage> {
  double _rating = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submit() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      String email = _emailController.text.trim();
      String review = _reviewController.text.trim();

      try {
        await FirebaseFirestore.instance.collection('ratings').add({
          'productId': widget.productId,
          'email': email,
          'review': review,
          'rating': _rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Get.snackbar(
        '✅ Success',
        'Thanks for your feedback',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 28,
        ),
        shouldIconPulse: false,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        barBlur: 10,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        snackStyle: SnackStyle.FLOATING,
      );

        Get.offAll(() => BottomBar());

        // Clear fields
        _reviewController.clear();
        setState(() {
          _rating = 0;
        });
      } catch (e) {
        Get.snackbar(
        '❌ Error',
        'Failed to submit your review. Try again!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.redAccent,
          size: 28,
        ),
        shouldIconPulse: false,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        barBlur: 10,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        snackStyle: SnackStyle.FLOATING,
      );
      }
    } else if (_rating == 0) {
      Get.snackbar(
        '❌ Error',
        'Please provide a star rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Rate Us", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "We'd love your feedback!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                allowHalfRating: true,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 40,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Email is required" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  labelText: "Write your review",
                  prefixIcon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? "Please write a review" : null,
              ),

              const SizedBox(height: 25),

              MyButton(title: 'Submit', height: 50, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
