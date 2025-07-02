import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/forgotPasswordController.dart';
import 'package:laptop_harbor/controller/loginController.dart';

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                                    onPressed: () async{
                                      if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    String useremail = email.text.trim();
                                    await forgotpasswordcontroller.ForgotPassword(useremail);
                                    }else{
                                      Get.snackbar(
                                          'Error',
                                          'Please enter a valid email',
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
                                      'Reset Password',
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
