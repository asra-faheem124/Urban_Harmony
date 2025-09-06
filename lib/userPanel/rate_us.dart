import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class RateUsPage extends StatefulWidget {
  final String id; // can be productId or designId
  final bool isDesign; // ✅ new flag to know which collection

  RateUsPage({required this.id, this.isDesign = false});

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
        // ✅ Choose correct collection
        final collection =
            widget.isDesign ? 'design_ratings' : 'ratings';

        await FirebaseFirestore.instance.collection(collection).add({
          if (widget.isDesign) 'designId': widget.id,
          if (!widget.isDesign) 'productId': widget.id,
          'email': email,
          'review': review,
          'rating': _rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        greenSnackBar('✅ Success!', 'Thanks for your feedback.');
        Get.offAll(() => BottomBar());

        _reviewController.clear();
        setState(() {
          _rating = 0;
        });
      } catch (e) {
        redSnackBar('❌ Error!', 'Failed to submit your review. Try again!');
      }
    } else if (_rating == 0) {
      redSnackBar('❌ Error!', 'Please provide a star rating.');
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
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              User_Heading(title: 'Rate Us'),
              const Text("We'd love your feedback!", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),

              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => setState(() => _rating = rating),
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

              MyButton(title: 'Submit', height: 50.0, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
