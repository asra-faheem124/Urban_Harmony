import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/create_new_password.dart';

class EditProfile extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.person, size: 60),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Profile Settings",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: name,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: phone,
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (!RegExp(r'^\d{10,}$').hasMatch(value)) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChangePassword(),
                                ),
                              );
                            },
                            child: const Text("Create New Password?"),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Container(
                            width: 170,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Success Snackbar
                                  Get.snackbar(
                                    '✅ Success',
                                    'Profile updated successfully!',
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
                                  Get.offAll(() => const BottomBar());
                                } else {
                                  // Error Snackbar
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
                                    shouldIconPulse: false,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                    barBlur: 10,
                                    duration: const Duration(seconds: 4),
                                    isDismissible: true,
                                    forwardAnimationCurve: Curves.easeOutBack,
                                    snackStyle: SnackStyle.FLOATING,
                                  );
                                }
                              },
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
