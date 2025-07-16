import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/checkoutController.dart';

class Payment extends StatefulWidget {
  final VoidCallback onConfirm;
  const Payment({super.key, required this.onConfirm});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final checkoutController = Get.find<CheckoutController>();
  String selectedMethod = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Payment Method", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildMethodTile("Google Pay", "google.png"),
          buildMethodTile("Cash On Delivery", "cod.png"),
          buildMethodTile("EasyPaisa", "easypaisa.png"),
          const SizedBox(height: 20),
          ElevatedButton(
           onPressed: () {
  if (selectedMethod.isEmpty) {
    Get.snackbar(
      '❌ Error',
      'Please select a payment method.',
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
    return;
  }

  // Save selection
  checkoutController.paymentMethod.value = selectedMethod;

  // Show success snackbar
  Get.snackbar(
    '✅ Success',
    'Payment method selected successfully!',
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

  // Trigger next step (e.g. navigate or confirm)
  widget.onConfirm();
},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildMethodTile(String method, String iconName) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/images/$iconName"),
      ),
      title: Text(method),
      trailing: Radio<String>(
        value: method,
        groupValue: selectedMethod,
        onChanged: (value) {
          setState(() {
            selectedMethod = value!;
          });
        },
      ),
    );
  }
}
