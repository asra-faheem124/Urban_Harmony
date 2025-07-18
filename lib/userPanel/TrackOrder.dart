import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class TrackOrderPage extends StatelessWidget {
  final String orderId;

  TrackOrderPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final trackingRef = FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .collection("trackingSteps")
        .orderBy("date", descending: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            User_Heading(title: 'Track order'),
            Text("Order ID: $orderId", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            /// Firestore Tracking Steps
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: trackingRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                    return const Center(child: Text("No tracking updates yet."));

                  final steps = snapshot.data!.docs.map((doc) {
                    final Timestamp ts = doc['date'];
                    final formattedDate =
                        DateFormat('dd MMM yyyy, hh:mm a').format(ts.toDate());

                    return TrackingStep(
                      doc['title'],
                      formattedDate,
                      doc['isCompleted'],
                    );
                  }).toList();

                  return ListView.builder(
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      return TrackStepTile(
                        step: steps[index],
                        isFirst: index == 0,
                        isLast: index == steps.length - 1,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingStep {
  final String title;
  final String date;
  final bool isCompleted;

  TrackingStep(this.title, this.date, this.isCompleted);
}

class TrackStepTile extends StatelessWidget {
  final TrackingStep step;
  final bool isFirst;
  final bool isLast;

  const TrackStepTile({
    required this.step,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: step.isCompleted ? Colors.black : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 12),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(step.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}