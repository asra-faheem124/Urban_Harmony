import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/TrackOrder.dart';

class OrdersHistoryPage extends StatelessWidget {
  OrdersHistoryPage({super.key});

  final String? email = FirebaseAuth.instance.currentUser?.email?.toLowerCase().trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('My Orders', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 1,
      ),
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

          final orders = snapshot.data!.docs.where((doc) {
            final docEmail = doc['user'].toString().toLowerCase().trim();
            return docEmail == email;
          }).toList();

          if (orders.isEmpty) {
            return const Center(child: Text("You haven’t placed any orders yet."));
          }

          return Padding(
            padding: const EdgeInsets.all(12),
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
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Order ID and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text("Order #$orderId",
                                  style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                            ),
                            Text(
                              "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const Divider(),

                        /// Items
                        const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...items.map((item) {
                          final name = item['name'];
                          final quantity = item['quantity'];
                          final price = item['price'];
                          final image = item['image'];
                          final hasImage = image != null && image.toString().length > 100;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                       Image.memory(
                                          base64Decode(image),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        )
                                      
                                ),
                                const SizedBox(width: 12),
                                // Product info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name,
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text("Quantity: x$quantity"),
                                      Text("PKR $price"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 10),
                        const Divider(),

                        /// Pricing Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Delivery Charges:"),
                            Text("PKR $deliveryCharge"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("PKR $total",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        /// Payment & Shipping
                        Text("Payment Method: $paymentMethod"),
                        const SizedBox(height: 8),
                        const Text("Shipping Info:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Name: ${shipping['name']}"),
                        Text("Phone: ${shipping['phone']}"),
                        Text("Address: ${shipping['address']}"),
                        Text("Postal Code: ${shipping['postalCode']}"),

                        const SizedBox(height: 12),

                        /// Track Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.to(() => TrackOrderPage(orderId: orderId)),
                            icon: const Icon(Icons.local_shipping),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            label: const Text("Track Order"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
