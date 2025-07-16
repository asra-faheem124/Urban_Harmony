import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/checkoutController.dart';

class Shipping extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final VoidCallback onConfirm;

  Shipping({super.key, required this.onConfirm});

  final checkoutController = Get.put(CheckoutController());

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final postalCodeController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Enter Shipping Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 360,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Your Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                          return 'Enter a valid phone number (10–15 digits)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: postalCodeController,
                      decoration: const InputDecoration(
                        hintText: 'Postal Code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your postal code';
                        }
                        if (!RegExp(r'^\d{4,10}$').hasMatch(value)) {
                          return 'Enter a valid postal code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Your Complete address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        if (value.length < 10) {
                          return 'Address must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                        // Save data to controller
                        checkoutController.name.value = nameController.text;
                        checkoutController.phone.value = phoneController.text;
                        checkoutController.postalCode.value =
                            postalCodeController.text;
                        checkoutController.address.value =
                            addressController.text;

                        onConfirm(); // move to next step
                         Get.snackbar(
                                      '✅ Success',
                                      'Shipping detils submitted successfully!',
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
                        }else{
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
