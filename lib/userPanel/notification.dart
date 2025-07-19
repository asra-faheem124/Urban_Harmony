import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    markAllAsRead(); // 👈 Automatically mark all as read when page opens
  }

   Future<void> markAllAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: user.uid)
        .where("isRead", isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({"isRead": true});
    }
  }
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("notifications")
                .where("userId", isEqualTo: userId)
                .orderBy("timestamp", descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Stream error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          return Column(
            children: [
              User_Heading(title: 'Notifications'),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final doc = notifications[index];
                    final data = doc.data() as Map<String, dynamic>;
                
                    return ListTile(
                      leading: Icon(
                        (data["isRead"] ?? false)
                            ? Icons.notifications_none
                            : Icons.notifications,
                        color: (data["isRead"] ?? false) ? Colors.grey : Colors.blue,
                      ),
                      title: Text(data["title"] ?? "No Title"),
                      subtitle: Text(data["message"] ?? "No message"),
                      trailing: Text(
                        (data["timestamp"] is Timestamp)
                            ? (data["timestamp"] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                                .split('.')[0]
                            : "",
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        doc.reference.update({"isRead": true});
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
