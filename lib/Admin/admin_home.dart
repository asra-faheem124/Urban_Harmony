import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor/userPanel/Widgets/drawer.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<int> getCount(String collection) async {
    var snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.length;
  }

  Future<double> getRevenue() async {
    var orders = await FirebaseFirestore.instance.collection('orders').get();
    double total = 0;
    for (var doc in orders.docs) {
      total += doc['totalAmount'] ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            width: 100,
            child: Image.asset('assets/images/logo2.png'),
          ),
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    // Open the right-side drawer
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      endDrawer: DrawerWidget(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder(
              future: Future.wait([
                getCount('User'),
                getCount('ratings'),
                getCount('contactMessages'),
                getRevenue(),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                final data = snapshot.data!;
                return Column(
                   children: [
    buildStatCard('Total Users', data[0].toString(), Icons.person, Colors.teal),
    buildStatCard('Total Ratings', data[1].toString(), Icons.star, Colors.amber),
    buildStatCard('Feedback Messages', data[2].toString(), Icons.message, Colors.deepPurple),
  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

Widget buildStatCard(String title, String value, IconData icon, Color color) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(12),
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}

}
