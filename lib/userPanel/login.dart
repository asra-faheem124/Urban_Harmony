import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/controller/loginController.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/forgotPassword.dart';
import 'package:laptop_harbor/userPanel/signup.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Logincontroller logincontroller = Get.put(Logincontroller());
    final Getuserdatacontroller getuserdatacontroller = Get.put(
      Getuserdatacontroller(),
    );
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/splash.jpg'), fit: BoxFit.cover)
                ),
                child: Image.asset('assets/images/logo.png'),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Login into \nyour account',
                            style: TextStyle(fontSize: 28, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 30),
                      
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Please enter your email";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
                        SizedBox(height: 30),
                        Container(
                          child: Obx(
                            () => TextFormField(
                              controller: password,
                              obscureText: !logincontroller.isVisible.value,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    logincontroller.isVisible.toggle();
                                  },
                                  child:
                                      logincontroller.isVisible.value
                                          ? FaIcon(FontAwesomeIcons.eyeSlash)
                                          : FaIcon(FontAwesomeIcons.eye),
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
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPassword();
                                  },
                                ),
                              );
                            },
                            child: Text("Forgot Password?"),
                          ),
                        ),
              
                        SizedBox(height: 50),
                        Center(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyButton(title: 'LOGIN',height: 50, onPressed: () async {
                                   if (_formKey.currentState != null &&
                                          _formKey.currentState!.validate()) {
                                        String useremail = email.text.trim();
                                        String userpassword = password.text.trim();
              
                                        UserCredential? userCredential =
                                            await logincontroller.LogInMethod(
                                              useremail,
                                              userpassword,
                                            );
              
                                        if (userCredential != null) {
                                          var userData = await getuserdatacontroller
                                              .getuserdata(
                                                userCredential.user!.uid,
                                              );
              
                                          if (userCredential.user!.emailVerified) {
                                            if (userData[0]['isAdmin'] == true) {
                                              Get.snackbar(
                                            '✅ Success',
                                            'Login Successful! Welcome to admin dashboard',
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
                                            duration: const Duration(
                                              seconds: 4,
                                            ),
                                            isDismissible: true,
                                            forwardAnimationCurve:
                                                Curves.easeOutBack,
                                            snackStyle: SnackStyle.FLOATING,
                                          );
                                              Get.offAll(AdminHomeScreen());
                                            } else {
                                             Get.snackbar(
                                            '✅ Success',
                                            'Login Successful! Welcome to your dashboard',
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
                                            duration: const Duration(
                                              seconds: 4,
                                            ),
                                            isDismissible: true,
                                            forwardAnimationCurve:
                                                Curves.easeOutBack,
                                            snackStyle: SnackStyle.FLOATING,
                                          );
                                              Get.offAll(BottomBar());
                                            }
                                          } else {
                                             Get.snackbar(
                                          '❌ Error',
                                          'Please verify your email',
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
                                          forwardAnimationCurve:
                                              Curves.easeOutBack,
                                          snackStyle: SnackStyle.FLOATING,
                                        );
                                          }
                                        }
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
                                          forwardAnimationCurve:
                                              Curves.easeOutBack,
                                          snackStyle: SnackStyle.FLOATING,
                                        );
                                      }
                                }),
                                SizedBox(height: 30),
                                Text(
                                  'or signin with',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.apple,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.google,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.facebook,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SignUp();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Signup',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
