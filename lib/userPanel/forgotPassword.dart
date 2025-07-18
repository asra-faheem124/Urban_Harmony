import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/forgotPasswordController.dart';
import 'package:laptop_harbor/controller/loginController.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class ForgotPassword extends StatelessWidget {
    final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Forgotpasswordcontroller forgotpasswordcontroller = Get.put(Forgotpasswordcontroller());
    final Logincontroller logincontroller = Get.put(Logincontroller());
    TextEditingController email = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: 370,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
               User_Heading(title: 'Forgot Password'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
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
                ),
              
                SizedBox(height: 30,),
              Center(
                child: MyButton(title: 'Reset Password',height: 50, onPressed: () async {
                   if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    String useremail = email.text.trim();
                                    await forgotpasswordcontroller.ForgotPassword(useremail);
                                    }else{
                                     redSnackBar('Error!',
                                          'Please enter a valid email.');
                                    }
                })
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
