import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/Widgets/tracking.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminOrderDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> trackingSteps = [
  {
    "title": "Sender is preparing to ship your order",
    "offset": Duration(hours: 0),
  },
  {
    "title": "Sender has shipped your parcel",
    "offset": Duration(hours: 4),
  },
  {
    "title": "Parcel is in transit",
    "offset": Duration(hours: 12),
  },
  {
    "title": "Parcel is received at delivery Branch",
    "offset": Duration(days: 1),
  },
  {
    "title": "Parcel is out for delivery",
    "offset": Duration(days: 2),
  },
  {
    "title": "Parcel is successfully delivered",
    "offset": Duration(days: 3),
  },
];

  final String orderId;

 AdminOrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc(orderId);
    final trackingCollection = orderDoc.collection('trackingSteps');
    final trackingQuery = trackingCollection.orderBy('date', descending: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: orderDoc.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = List<Map<String, dynamic>>.from(data['items']);
          final shipping = data['shipping'] ?? {};
          final payment = data['paymentMethod'];
          final total = data['total'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Admin_Heading(title: 'Order Details'),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    children: [
                      Text("Order ID: $orderId", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("User: ${data['user']}"),
                      Text("Payment: $payment"),
                      const SizedBox(height: 10),
                      Text("Shipping Info:"),
                      Text("Name: ${shipping['name']}"),
                      Text("Phone: ${shipping['phone']}"),
                      Text("Address: ${shipping['address']}"),
                      Text("Postal Code: ${shipping['postalCode']}"),
                      const Divider(height: 30),
                      const Text("Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                      ...items.map((item) {
                        Uint8List? imageBytes;
                        try {
                          imageBytes = base64Decode(item['image']);
                        } catch (_) {
                          imageBytes = null;
                        }

                        return ListTile(
                          leading: imageBytes != null
                              ? Image.memory(imageBytes, width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported),
                          title: Text(item['name']),
                          subtitle: Text("Qty: ${item['quantity']}"),
                          trailing: Text("PKR ${item['price']}"),
                        );
                      }).toList(),

                      const Divider(height: 30),
                      Text("Total: PKR $total", style: const TextStyle(fontWeight: FontWeight.bold)),

                      const SizedBox(height: 30),
                      const Text("Tracking Steps", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      StreamBuilder<QuerySnapshot>(
                        stream: trackingQuery.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const CircularProgressIndicator();
                          if (snapshot.data!.docs.isEmpty) return const Text("No tracking steps yet.");

                          return Column(
                            children: snapshot.data!.docs.map((doc) {
                              final step = doc.data() as Map<String, dynamic>;
                              return ListTile(
                                leading: Icon(step['isCompleted'] ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: step['isCompleted'] ? Colors.green : Colors.grey),
                                title: Text(step['title']),
                                subtitle: Text(step['date'].toString()),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
               TrackingDropdown(orderId: orderId)
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTrackingStepDialog(BuildContext context, CollectionReference trackingCollection) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Tracking Step"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Step Title"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isEmpty) return;

              await trackingCollection.add({
                "title": title,
"date": Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
                "isCompleted": false,
              });

              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
