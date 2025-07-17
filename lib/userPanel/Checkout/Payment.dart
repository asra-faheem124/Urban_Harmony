import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/checkoutController.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

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
          const Text(
            "Payment Method",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          buildMethodTile("Google Pay", "google.png"),
          buildMethodTile("Cash On Delivery", "cod.png"),
          buildMethodTile("EasyPaisa", "easypaisa.png"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedMethod.isEmpty) {
                redSnackBar('❌ Error!', 'Please select a payment method.');
                return;
              }

              // Save selection
              checkoutController.paymentMethod.value = selectedMethod;

              // Show success snackbar
              greenSnackBar(
                '✅ Success!',
                'Payment method selected successfully.',
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
