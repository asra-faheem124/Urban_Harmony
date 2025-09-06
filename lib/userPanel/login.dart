import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/DesignerPanel/Designer_home.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/controller/loginController.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        User_Heading(title: 'Login into \nyour account'),
                        SizedBox(height: 30),

                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Please enter your email";
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
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
                                MyButton(
                                  title: 'LOGIN',
                                  height: 50.0,
                                  onPressed: () async {
                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      String useremail = email.text.trim();
                                      String userpassword =
                                          password.text.trim();

                                      UserCredential? userCredential =
                                          await logincontroller.LogInMethod(
                                            useremail,
                                            userpassword,
                                          );

                                      if (userCredential != null) {
                                        var userData =
                                            await getuserdatacontroller
                                                .getuserdata(
                                                  userCredential.user!.uid,
                                                );

                                        if (userCredential
                                            .user!
                                            .emailVerified) {
                                          String role =
                                              userData[0]['role'] ??
                                              'user'; // <-- get role

                                          if (role == 'admin') {
                                            greenSnackBar(
                                              '✅ Success!',
                                              'Login Successful! Welcome to admin dashboard.',
                                            );
                                            Get.offAll(AdminHomeScreen());
                                          } else if (role == 'designer') {
                                            greenSnackBar(
                                              '✅ Success!',
                                              'Login Successful! Welcome to designer dashboard.',
                                            );
                                            Get.offAll(
                                              DesignerHomeScreen(),
                                            ); // replace with your designer dashboard
                                          } else {
                                            greenSnackBar(
                                              '✅ Success!',
                                              'Login Successful! Welcome to your dashboard.',
                                            );
                                            Get.offAll(BottomBar());
                                          }
                                        } else {
                                          redSnackBar(
                                            '❌ Error!',
                                            'Please verify your email.',
                                          );
                                        }
                                      }
                                    } else {
                                      redSnackBar(
                                        '❌ Error!',
                                        'Please fill out all the fields correctly.',
                                      );
                                    }
                                  },
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
            ],
          ),
        ),
      ),
    );
  }
}
