import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/design_detail.dart';

class TopRatedDesignsGrid extends StatefulWidget {
  const TopRatedDesignsGrid({super.key});

  @override
  State<TopRatedDesignsGrid> createState() => _TopRatedDesignsGridState();
}

class _TopRatedDesignsGridState extends State<TopRatedDesignsGrid> {
  Future<List<Map<String, dynamic>>> _fetchTopRatedDesigns() async {
    final designSnapshot =
        await FirebaseFirestore.instance.collection('design').get();

    List<Map<String, dynamic>> designsWithRatings = [];

    for (var doc in designSnapshot.docs) {
      final designData = doc.data();
      final designId = doc.id; 

      final ratingsSnapshot = await FirebaseFirestore.instance
          .collection('design_ratings') 
          .where('designId', isEqualTo: designId)
          .get();

      double total = 0;
      for (var ratingDoc in ratingsSnapshot.docs) {
        total += ratingDoc['rating'];
      }

      double avgRating =
          ratingsSnapshot.docs.isEmpty ? 0.0 : total / ratingsSnapshot.docs.length;

      designsWithRatings.add({
        ...designData,
        'designId': designId,
        'avgRating': avgRating,
        'ratingCount': ratingsSnapshot.docs.length,
      });
    }

    designsWithRatings.sort((a, b) => b['avgRating'].compareTo(a['avgRating']));
    return designsWithRatings.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchTopRatedDesigns(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Top Rated Designs Found"));
        }

        final designs = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: designs.length,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final data = designs[index];
            final imageBytes = base64Decode(data['designImage']); 
            final avg = data['avgRating'];
            final count = data['ratingCount'];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.memory(imageBytes, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['designName'], 
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              avg.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              ' ($count)',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['designDesc'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           
                            ElevatedButton(
                              onPressed: () {
                                Get.to(() => DesignDetailPage(designData: data));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                textStyle: const TextStyle(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Details"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
