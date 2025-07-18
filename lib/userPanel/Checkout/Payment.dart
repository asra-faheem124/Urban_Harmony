import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  final VoidCallback onConfirm;
  const Payment({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment_rounded, size: 80, color: Colors.black87),
            const SizedBox(height: 20),
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade700, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.local_shipping, size: 40, color: Colors.brown),
                  SizedBox(height: 10),
                  Text(
                    "Currently, only Cash On Delivery (COD) is allowed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
