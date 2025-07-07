import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      title: Text('All Users', style: headingStyle,),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('User').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Password')),
              ],
              rows: users.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return DataRow(cells: [
                  DataCell(Text(data['name'] ?? '')),
                  DataCell(Text(data['email'] ?? '')),
                  DataCell(Text(data['phoneNumber'] ?? '')),
                  DataCell(Text(data['password'] ?? '')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
