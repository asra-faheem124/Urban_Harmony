import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/create_new_password.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load Firestore data into text fields
  }

  void loadUserData() async {
    final uid = auth.currentUser!.uid;
    DocumentSnapshot userDoc =
        await firestore.collection('User').doc(uid).get();
    final data = userDoc.data() as Map<String, dynamic>;

    name.text = data['name'] ?? '';
    email.text = data['email'] ?? '';
    phone.text = data['phoneNumber'] ?? '';
  }

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
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
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
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
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
                        TextFormField(
                          controller: phone,
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
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
                          child: MyButton(title: 'Save Changes', onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                  final uid = auth.currentUser!.uid;

                                  await firestore
                                      .collection('User')
                                      .doc(uid)
                                      .update({
                                        'name': name.text.trim(),
                                        'email': email.text.trim(),
                                        'phoneNumber': phone.text.trim(),
                                      });

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

                                  Get.offAll(() => const BottomBar());
                                } else {
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
                          })
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
