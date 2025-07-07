import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting timestamp

class AdminRatingsPage extends StatelessWidget {
  const AdminRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Ratings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ratings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No ratings available.'));
          }

          final ratings = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Rating')),
                DataColumn(label: Text('Review')),
                DataColumn(label: Text('Date')),
              ],
              rows: ratings.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final timestamp = data['timestamp'] as Timestamp?;
                final formattedDate = timestamp != null
                    ? DateFormat('dd MMM yyyy, hh:mm a')
                        .format(timestamp.toDate())
                    : 'N/A';

                return DataRow(cells: [
                  DataCell(Text(data['email'] ?? '')),
                  DataCell(Row(
                    children: List.generate(
                      data['rating'] ?? 0,
                      (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  )),
                  DataCell(Text(data['review'] ?? '')),
                  DataCell(Text(formattedDate)),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
