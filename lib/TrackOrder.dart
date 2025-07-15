import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrackOrderPage extends StatelessWidget {
  final List<TrackingStep> steps = [
    TrackingStep("Parcel is successfully delivered", "15 May 10:20", true),
    TrackingStep("Parcel is out for delivery", "15 May 08:00", true),
    TrackingStep("Parcel is received at delivery Branch", "13 May 17:25", true),
    TrackingStep("Parcel is in transit", "13 May 07:00", true),
    TrackingStep("Sender has shipped your parcel", "12 May 14:25", true),
    TrackingStep("Sender is preparing to ship your order", "12 May 10:41", true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: Text("Track Order", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Delivered on 15.05.21", style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: 'Tracking Number: ',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                children: [
                  TextSpan(
                    text: 'IK287368838',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return TrackStepTile(
                    step: step,
                    isFirst: index == 0,
                    isLast: index == steps.length - 1,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            RateCard(),
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
              child: Icon(Icons.check, color: Colors.white, size: 12),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text(step.date, style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.star, color: Colors.orange, size: 32),
          SizedBox(height: 8),
          Text("Don't forget to rate", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Rate product to get 5 points for collect.",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(Icons.star_border, color: Colors.orange, size: 28);
            }),
          )
        ],
      ),
    );
  }
}
