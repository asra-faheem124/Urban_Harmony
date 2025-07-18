import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderDetailsPage extends StatelessWidget {
  final String orderId;

  const AdminOrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: orderDoc.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = List<Map<String, dynamic>>.from(data['items']);
          final shipping = data['shipping'] ?? {};
          final payment = data['paymentMethod'];
          final total = data['total'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text("Order ID: $orderId", style: TextStyle(fontWeight: FontWeight.bold)),
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
                ...items.map((item) => ListTile(
                      title: Text(item['name']),
                      subtitle: Text("Qty: ${item['quantity']}"),
                      trailing: Text("PKR ${item['price']}"),
                    )),
                const Divider(height: 30),
                Text("Total: PKR $total", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}
