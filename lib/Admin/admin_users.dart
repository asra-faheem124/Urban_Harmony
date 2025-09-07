import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('User').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          final users = snapshot.data!.docs;
          return ListView(
  padding: const EdgeInsets.all(12),
  children: [
    const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Registered Users',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ),
    ...users.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              data['name'] != null && data['name'].isNotEmpty
                  ? data['name'][0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(data['name'] ?? 'No Name',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['role'].toString().toUpperCase() ?? 'No Role', style: TextStyle(fontWeight: FontWeight.bold,),),
              Text(data['email'] ?? 'No Email'),
              Text(data['phoneNumber'] ?? 'No Phone'),
              Text(
                '*' * (data['password']?.length ?? 0),
                style: const TextStyle(letterSpacing: 2),
              ),
            ],
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete User"),
                      content: const Text(
                          "Are you sure you want to delete this user?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () =>
                              Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () =>
                              Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await FirebaseFirestore.instance
                        .collection('User')
                        .doc(doc.id)
                        .delete();
                  }
                },
              ),
            ],
          ),
        ),
      );
    }).toList(),
  ],
);

        },
      ),
    );
  }
}
