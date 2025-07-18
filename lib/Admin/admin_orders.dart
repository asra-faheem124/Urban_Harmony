import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laptop_harbor/Admin/order_details.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text("No orders found."));

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              final user = data['user'];
              final total = data['total'];
              final timestamp = (data['timestamp'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Order #$orderId"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User: $user"),
                      Text("Total: PKR $total"),
                      Text("Date: ${DateFormat('dd MMM yyyy').format(timestamp)}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminOrderDetailsPage(orderId: orderId),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
