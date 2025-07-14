import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminFeedbackPage extends StatelessWidget {
  const AdminFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('contactMessages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No feedback messages found.'));
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length + 1, // +1 for the heading
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header at the top of the list
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'User Feedback',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              }

              final data = messages[index - 1].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate())
                  : 'N/A';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.subject, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(
                            data['subject'] ?? 'No Subject',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['message'] ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Icon(Icons.person, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(data['name'] ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          Icon(Icons.email, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
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
