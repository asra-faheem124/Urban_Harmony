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
    "Parcel is successfully delivered"
  ];

  @override
  void initState() {
    super.initState();
    addInitialStepIfNoneExists();
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

    // Clear existing tracking steps (optional: remove this if you want to keep history)
    final docs = await ref.get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }

    DateTime now = DateTime.now();
    for (int i = 0; i <= index; i++) {
      await ref.add({
        "title": steps[i],
        "date": now.add(Duration(hours: i * 4)).toString(),
        "isCompleted": true,
      });
    }

    for (int i = index + 1; i < steps.length; i++) {
      await ref.add({
        "title": steps[i],
        "date": now.add(Duration(hours: i * 4)).toString(),
        "isCompleted": false,
      });
    }

    setState(() {
      selectedStep = index;
    });

greenSnackBar("✅ Tracking Updated", "Current status: ${steps[index]}");  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text("Update Tracking Status", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: selectedStep,
          items: List.generate(steps.length, (index) {
            return DropdownMenuItem(
              value: index,
              child: Text(steps[index]),
            );
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
