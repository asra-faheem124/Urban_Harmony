import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/cartController.dart';
import 'package:laptop_harbor/controller/checkoutController.dart';
import 'package:laptop_harbor/userPanel/Checkout/Confirmation.dart';
import 'package:laptop_harbor/userPanel/TrackOrder.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final cartController = Get.put(Cartcontroller());
  final checkoutController = Get.put(CheckoutController());
  double deliveryCharge = 200.0;

  @override
  Widget build(BuildContext context) {
    final cartItems = cartController.cartItems;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Review Your Order",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Shipping Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Shipping Information",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("Name: ${checkoutController.name.value}"),
                Text("Phone: ${checkoutController.phone.value}"),
                Text(
                  "Address: ${checkoutController.address.value}, Postal Code: ${checkoutController.postalCode.value}",
                ),
                const SizedBox(height: 12),
                const Text(
                  "Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("Cash On Delivery"),
              ],
            ),
          ),

          const Divider(thickness: 1),

          // Product List
          Expanded(
            child:
                cartItems.isEmpty
                    ? const Center(child: Text("Your cart is empty."))
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final entry = cartItems.entries.elementAt(index);
                        final product = entry.key;
                        final quantity = entry.value;

                        Uint8List imageBytes = base64Decode(
                          product.productImage,
                        );
                        int unitPrice = int.tryParse(product.productPrice) ?? 0;
                        int totalPrice = unitPrice * quantity;

                        return ListTile(
                          leading: Image.memory(
                            imageBytes,
                            width: 60,
                            height: 60,
                          ),
                          title: Text(
                            product.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("x$quantity"),
                          trailing: Text(
                            "PKR $totalPrice",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
          ),

          // Order Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal", style: TextStyle(fontSize: 16)),
                    Text("PKR ${cartController.totalPrice.toStringAsFixed(0)}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Delivery Charges",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("PKR ${deliveryCharge.toStringAsFixed(0)}"),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "PKR ${(cartController.totalPrice + deliveryCharge).toStringAsFixed(0)}",
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                MyButton(
                  title: 'Confirm Order',
                  height: 50,
                  onPressed: () async {
                    await placeOrder();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ PLACE ORDER FUNCTION
  Future<void> placeOrder() async {
    final firestore = FirebaseFirestore.instance;
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'guest';
    const double deliveryCharge = 200.0;

    if (cartController.cartItems.isEmpty) {
      redSnackBar('Error', 'Your cart is empty');
      return;
    }

    if (checkoutController.name.value.isEmpty ||
        checkoutController.phone.value.isEmpty ||
        checkoutController.address.value.isEmpty ||
        checkoutController.postalCode.value.isEmpty) {
      redSnackBar('Missing Info', 'Complete shipping before placing order.');
      return;
    }

    try {
      final orderRef = await firestore.collection("orders").add({
        "user": userEmail,
        "shipping": {
          "name": checkoutController.name.value,
          "phone": checkoutController.phone.value,
          "postalCode": checkoutController.postalCode.value,
          "address": checkoutController.address.value,
        },
        "paymentMethod": 'Cash On Delivery',
        "items":
            cartController.cartItems.entries
                .map(
                  (entry) => {
                    "productId": entry.key.productId,
                    "name": entry.key.productName,
                    "price": entry.key.productPrice,
                    "quantity": entry.value,
                    "image": entry.key.productImage,
                  },
                )
                .toList(),
        "total": cartController.totalPrice + deliveryCharge,
        "deliveryCharge": deliveryCharge,
        "timestamp": DateTime.now(),
      });

      final now = DateTime.now();
      final trackingSteps = [
        {
          "title": "Sender is preparing to ship your order",
          "date": now,
          "isCompleted": true,
        },
        {
          "title": "Sender has shipped your parcel",
          "date": now.add(Duration(hours: 4)),
          "isCompleted": false,
        },
        {
          "title": "Parcel is in transit",
          "date": now.add(Duration(hours: 12)),
          "isCompleted": false,
        },
        {
          "title": "Parcel is received at delivery Branch",
          "date": now.add(Duration(days: 1)),
          "isCompleted": false,
        },
        {
          "title": "Parcel is out for delivery",
          "date": now.add(Duration(days: 2)),
          "isCompleted": false,
        },
        {
          "title": "Parcel is successfully delivered",
          "date": now.add(Duration(days: 3)),
          "isCompleted": false,
        },
      ];

      for (var step in trackingSteps) {
        await orderRef.collection("trackingSteps").add(step);
      }

      cartController.ClearCart();

      greenSnackBar('✅ Success!', 'Your order has been placed successfully.');
      Get.offAll(() => Confirmation(orderId: orderRef.id));
    } catch (e) {
      redSnackBar('❌ Error!', 'Failed to place order. Try again.');
      debugPrint("Order error: $e");
    }
  }
}
