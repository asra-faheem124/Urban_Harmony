import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';

class TrackingDropdown extends StatefulWidget {
  final String orderId;

  const TrackingDropdown({super.key, required this.orderId});

  @override
  State<TrackingDropdown> createState() => _TrackingDropdownState();
}

class _TrackingDropdownState extends State<TrackingDropdown> {
  int selectedStep = 0;

  final List<String> steps = [
    "Sender is preparing to ship your order",
    "Sender has shipped your parcel",
    "Parcel is in transit",
    "Parcel is received at delivery Branch",
    "Parcel is out for delivery",
    "Parcel is successfully delivered",
  ];

  @override
  void initState() {
    super.initState();
    addInitialStepIfNoneExists();
    fetchLatestStep();
  }

  Future<void> addInitialStepIfNoneExists() async {
    final ref = FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .collection("trackingSteps");

    final snapshot = await ref.get();
    if (snapshot.docs.isEmpty) {
      await ref.add({
        "title": steps[0],
        "date": DateTime.now().toString(),
        "isCompleted": true,
      });
    }
  }

  Future<void> updateTrackingStep(int index) async {
    final ref = FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .collection("trackingSteps");

    // Delete old tracking steps
    final docs = await ref.get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }

    DateTime now = DateTime.now();

    for (int i = 0; i <= index; i++) {
      await ref.add({
        "title": steps[i],
        "date": now.add(Duration(hours: i * 4)),
        "isCompleted": true,
      });
    }

    for (int i = index + 1; i < steps.length; i++) {
      await ref.add({
        "title": steps[i],
        "date": now.add(Duration(hours: i * 4)),
        "isCompleted": false,
      });
    }

    final orderSnapshot =
        await FirebaseFirestore.instance
            .collection("orders")
            .doc(widget.orderId)
            .get();
    final userId = orderSnapshot['userId'];

    // ✅ Add a notification
    final notificationQuery =
        await FirebaseFirestore.instance
            .collection("notifications")
            .where("orderId", isEqualTo: widget.orderId)
            .where(
              "message",
              isEqualTo: "Your order is now at this stage: ${steps[index]}",
            )
            .limit(1)
            .get();

    if (notificationQuery.docs.isEmpty) {
      await FirebaseFirestore.instance.collection("notifications").add({
        "userId": userId,
        "orderId": widget.orderId,
        "title": "Order Update",
        "message": "Your order is now at this stage: ${steps[index]}",
        "timestamp": FieldValue.serverTimestamp(),
        "isRead": false,
      });
    }

    setState(() {
      selectedStep = index;
    });

    greenSnackBar("✅ Tracking Updated", "Current status: ${steps[index]}");
  }

  Future<void> fetchLatestStep() async {
    final ref = FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .collection("trackingSteps");

    final snapshot = await ref.orderBy("date").get();

    if (snapshot.docs.isEmpty) {
      // Add initial step if none exists
      await ref.add({
        "title": steps[0],
        "date": DateTime.now().toString(),
        "isCompleted": true,
      });
      selectedStep = 0;
    } else {
      // Get the last completed step
      int latestCompletedIndex = 0;
      for (int i = 0; i < snapshot.docs.length; i++) {
        if (snapshot.docs[i]['isCompleted'] == true) {
          latestCompletedIndex = i;
        }
      }
      selectedStep = latestCompletedIndex;
    }

    setState(() {}); // Refresh the dropdown with latest value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          "Update Tracking Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: selectedStep >= 0 ? selectedStep : null,
          hint: const Text("Select a status"),
          items: List.generate(steps.length, (index) {
            return DropdownMenuItem(value: index, child: Text(steps[index]));
          }),
          onChanged: (value) {
            if (value != null) {
              updateTrackingStep(value);
            }
          },
        ),
      ],
    );
  }
}
