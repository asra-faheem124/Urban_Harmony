import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/signupController.dart';
import 'package:laptop_harbor/userPanel/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    //declaring controllers
    final Signupcontroller signupcontroller = Get.put(Signupcontroller());
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController phoneNumber = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
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
                      'Create \nyour account',
                      style: TextStyle(fontSize: 28, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: Obx(
                      () => TextFormField(
                        controller: password,
                        obscureText: !signupcontroller.isVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signupcontroller.isVisible.toggle();
                            },
                            child:
                                signupcontroller.isVisible.value
                                    ? FaIcon(FontAwesomeIcons.eyeSlash)
                                    : FaIcon(FontAwesomeIcons.eye),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: phoneNumber,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black),
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
                                String username = name.text.trim();
                                String useremail = email.text.trim();
                                String userpassword = password.text.trim();
                                String userphoneNumber =
                                    phoneNumber.text.trim();
                                if (username.isEmpty ||
                                    useremail.isEmpty ||
                                    userpassword.isEmpty ||
                                    userphoneNumber.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill out all the fields',
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
                                  return;
                                } else {
                                  UserCredential? userCredential =
                                      await signupcontroller.SignUpMethod(
                                        username,
                                        useremail,
                                        userpassword,
                                        userphoneNumber,
                                      );
                                  if (userCredential != null) {
                                    Get.snackbar(
                                      'Success',
                                      'Signup Successfull! Please verify your email address',
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.white,
                                        colorText: Colors.black,
                                        margin: EdgeInsets.all(16),
                                        borderRadius: 8,
                                        icon: Icon(Icons.check_circle, color: Colors.black,)
                                      
                                    );
                                    Get.to(Login());
                                  }
                                }
                              },
                              child: Text(
                                'SIGNUP',
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
                            'or signup with',
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
                                'Already have an account?',
                                style: TextStyle(fontSize: 14),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Login();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Login',
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
    );
  }
}
