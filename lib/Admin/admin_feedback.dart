import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminFeedbackPage extends StatelessWidget {
  const AdminFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Feedback')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('contactMessages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No feedback messages found.'));
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final data = messages[index].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? DateFormat('dd MMM yyyy, hh:mm a')
                      .format(timestamp.toDate())
                  : 'N/A';

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.subject, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            data['subject'] ?? 'No Subject',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        data['message'] ?? '',
                        style: TextStyle(fontSize: 15),
                      ),
                      Divider(height: 20),
                      Row(
                        children: [
                          Icon(Icons.person, size: 18, color: Colors.grey[700]),
                          SizedBox(width: 4),
                          Text(data['name'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(width: 12),
                          Icon(Icons.email, size: 18, color: Colors.grey[700]),
                          SizedBox(width: 4),
                          Text(data['email'] ?? ''),
                        ],
                      ),
                    ],
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
