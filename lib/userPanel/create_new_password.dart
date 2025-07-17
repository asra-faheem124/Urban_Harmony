import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool obscureCurrent = true.obs;
  final RxBool obscureNew = true.obs;
  final RxBool obscureConfirm = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> changePassword() async {
    try {
      final user = _auth.currentUser!;
      final String currentPass = currentPasswordController.text.trim();
      final String newPass = newPasswordController.text.trim();

      // Step 1: Re-authenticate
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPass,
      );
      await user.reauthenticateWithCredential(cred);

      // Step 2: Update password in FirebaseAuth
      await user.updatePassword(newPass);

      await _firestore.collection('User').doc(user.uid).update({
        'password': newPass,
        'passwordChangedAt': FieldValue.serverTimestamp(),
      });

      // Step 4: Notify success
      greenSnackBar('✅ Success!', 'Password changed successfully.');

      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Something went wrong. Try again later.';
      if (e.code == 'wrong-password') {
        errorMsg = 'Current password is incorrect';
      } else if (e.code == 'weak-password') {
        errorMsg = 'Password must be at least 6 characters';
      }

      redSnackBar('❌ Error', 'Some error has occured.');
    } catch (e) {
      redSnackBar('❌ Error!', 'Unexpected error occurred: ${e.toString()}.');
    }
  }

  @override
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Password?',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => TextFormField(
                            controller: currentPasswordController,
                            obscureText: obscureCurrent.value,
                            decoration: InputDecoration(
                              hintText: 'Current Password',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureCurrent.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed:
                                    () =>
                                        obscureCurrent.value =
                                            !obscureCurrent.value,
                              ),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? 'Enter current password'
                                        : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => TextFormField(
                            controller: newPasswordController,
                            obscureText: obscureNew.value,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              suffixIcon: GestureDetector(
                                onTap:
                                    () => obscureNew.value = !obscureNew.value,
                                child:
                                    obscureNew.value
                                        ? Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => TextFormField(
                            controller: confirmPasswordController,
                            obscureText: obscureConfirm.value,
                            decoration: InputDecoration(
                              hintText: 'Confirm New Password',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirm.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed:
                                    () =>
                                        obscureConfirm.value =
                                            !obscureConfirm.value,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm your password';
                              }
                              if (value != newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: MyButton(
                            title: 'Update',
                            height: 50,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                changePassword();
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
