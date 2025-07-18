import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/TrackOrder.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class OrdersHistoryPage extends StatelessWidget {
  OrdersHistoryPage({super.key});

  final String? email = FirebaseAuth.instance.currentUser?.email?.toLowerCase().trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("You haven’t placed any orders yet."));
          }

          // Filter only this user's orders (since we removed where clause)
          final orders = snapshot.data!.docs.where((doc) {
            final docEmail = doc['user'].toString().toLowerCase().trim();
            return docEmail == email;
          }).toList();

          if (orders.isEmpty) {
            return const Center(child: Text("You haven’t placed any orders yet."));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                User_Heading(title: 'My Orders'),
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final data = orders[index].data() as Map<String, dynamic>;
                      final orderId = orders[index].id;
                      final total = data['total'];
                      final deliveryCharge = data['deliveryCharge'];
                      final date = (data['timestamp'] as Timestamp).toDate();
                      final paymentMethod = data['paymentMethod'];
                      final items = List<Map<String, dynamic>>.from(data['items']);
                      final shipping = data['shipping'];

                      return Card(
                        color: Colors.grey[100],
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order ID: $orderId", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Date: ${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}"),
                              const Divider(),

                              const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              ...items.map((item) {
                                final name = item['name'];
                                final quantity = item['quantity'];
                                final price = item['price'];
                                  final image = item['image']; 
                                return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image display
        if (image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
                  base64Decode(image),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
          ),
        const SizedBox(width: 12),
        // Product details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("x$quantity"),
              Text("PKR $price"),
            ],
          ),
        ),
      ],
    ),
  );
}).toList(),

                              const SizedBox(height: 8),
                              Text("Delivery Charges: PKR $deliveryCharge"),
                              Text("Total: PKR $total", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("Payment Method: $paymentMethod"),
                              const SizedBox(height: 8),

                              const Text("Shipping Info:", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("Name: ${shipping['name']}"),
                              Text("Phone: ${shipping['phone']}"),
                              Text("Address: ${shipping['address']}"),
                              Text("Postal Code: ${shipping['postalCode']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
