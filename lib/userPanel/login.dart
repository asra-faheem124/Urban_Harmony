import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/controller/loginController.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 370,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
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
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
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
                          // Navigator.push(context, MaterialPageRoute(builder: (context){
                          //   return ForgotPassword();
                          // }));
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
                            Container(
                              width: 130,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
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
                                            'Success',
                                            'Login Successful! Welcome to admin dashboard',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.white,
                                            colorText: Colors.black,
                                            margin: EdgeInsets.all(16),
                                            borderRadius: 8,
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.black,
                                            ),
                                          );
                                          Get.offAll(AdminHomeScreen());
                                        } else {
                                          Get.snackbar(
                                            'Success',
                                            'Login Successful! Welcome to your dashboard',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.white,
                                            colorText: Colors.black,
                                            margin: EdgeInsets.all(16),
                                            borderRadius: 8,
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.black,
                                            ),
                                          );
                                          Get.to(HomeScreen());
                                        }
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Please verify your email',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.black,
                                          colorText: Colors.white,
                                          margin: EdgeInsets.all(16),
                                          borderRadius: 8,
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Please fill out all fields correctly',
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.black,
                                      colorText: Colors.white,
                                      margin: EdgeInsets.all(16),
                                      borderRadius: 8,
                                      icon: Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },

                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'ProductSans-b',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
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
        ),
      ),
    );
  }
}
