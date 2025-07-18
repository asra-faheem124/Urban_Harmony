import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class ContactFeedbackPage extends StatefulWidget {
  ContactFeedbackPage({super.key});

  @override
  State<ContactFeedbackPage> createState() => _ContactFeedbackPageState();
}

class _ContactFeedbackPageState extends State<ContactFeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> subjects = [
    'General Inquiry',
    'Order Issue',
    'Technical Problem',
    'Suggestions',
    'Feedback',
    'Others',
  ];

  final RxString selectedSubject = 'General Inquiry'.obs;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                User_Heading(title: 'Contact & Feedback'),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Email field
                        TextFormField(
                          controller: emailController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Subject dropdown
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: selectedSubject.value,
                            items:
                                subjects
                                    .map(
                                      (subj) => DropdownMenuItem(
                                        value: subj,
                                        child: Text(subj),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              selectedSubject.value = value!;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Select Subject',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Message field
                        TextFormField(
                          controller: messageController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Enter your message',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            if (value.length < 10) {
                              return 'Message must be at least 10 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),

                        // Submit button
                        Center(
                          child: MyButton(
                            title: 'Submit',
                            height: 50,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await FirebaseFirestore.instance
                                    .collection('contactMessages')
                                    .add({
                                      'name': nameController.text.trim(),
                                      'email': emailController.text.trim(),
                                      'subject': selectedSubject.value,
                                      'message': messageController.text.trim(),
                                      'timestamp': FieldValue.serverTimestamp(),
                                    });
                                // Success snackbar
                                greenSnackBar(
                                  '✅ Success!',
                                  'Message sent successfully.',
                                );
                                Get.offAll(HomeScreen());
                                // Clear fields
                                nameController.clear();
                                emailController.clear();
                                messageController.clear();
                                selectedSubject.value = subjects[0];
                              } else {
                                // Error snackbar
                                redSnackBar(
                                  '❌ Error!',
                                  'Please fill out all the fields correctly.',
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
