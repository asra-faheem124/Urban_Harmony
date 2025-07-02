import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Home.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Center(
        child: Container(
          width: 370,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Create New Password?',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Your new password must be different\nfrom previously used password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),

                // New Password Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => TextFormField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword.value,
                      decoration: InputDecoration(
                        hintText: 'New Password',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            obscureNewPassword.value =
                                !obscureNewPassword.value;
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Confirm Password Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword.value,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            obscureConfirmPassword.value =
                                !obscureConfirmPassword.value;
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Confirm Button
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
                          // Success - Passwords are valid and match
                          Get.snackbar(
                            '✅ Success',
                            'Password changed successfully',
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } else {
                          Get.snackbar(
                            '❌ Error',
                            'Please fill out all the fields',
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
                      },
                      child: const Text(
                        'Confirm',
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
    );
  }
}
