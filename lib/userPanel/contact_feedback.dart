import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Home.dart';

class ContactFeedbackPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final List<String> subjects = [
    'General Inquiry',
    'Order Issue',
    'Technical Problem',
    'Suggestions',
    'Feedback',
    'Others',
  ];

  final RxString selectedSubject = 'General Inquiry'.obs;

  ContactFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Contact & Feedback',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
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
                                  Get.snackbar(
                                    '✅ Success',
                                    'Message sent successfully!',
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    barBlur: 10,
                                    duration: const Duration(seconds: 4),
                                    isDismissible: true,
                                    forwardAnimationCurve: Curves.easeOutBack,
                                    snackStyle: SnackStyle.FLOATING,
                                  );
                                  Get.offAll(HomeScreen());
                                  // Clear fields
                                  nameController.clear();
                                  emailController.clear();
                                  messageController.clear();
                                  selectedSubject.value = subjects[0];
                                } else {
                                  // Error snackbar
                                  Get.snackbar(
                                    '❌ Error',
                                    'Please fill out all the fields correctly.',
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    barBlur: 10,
                                    duration: const Duration(seconds: 4),
                                    isDismissible: true,
                                    forwardAnimationCurve: Curves.easeOutBack,
                                    snackStyle: SnackStyle.FLOATING,
                                  );
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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
