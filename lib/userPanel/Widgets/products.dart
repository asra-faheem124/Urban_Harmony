import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/ProductDetail.dart';

class DynamicProducts extends StatefulWidget {
  const DynamicProducts({super.key});

  @override
  State<DynamicProducts> createState() => _DynamicProductsState();
}

class _DynamicProductsState extends State<DynamicProducts> {
  Map<String, Map<String, dynamic>> _ratingsCache = {};

  Future<Map<String, dynamic>> _getRatings(String productId) async {
    if (_ratingsCache.containsKey(productId)) {
      return _ratingsCache[productId]!;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('productId', isEqualTo: productId)
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['rating'];
    }

    double average = snapshot.docs.isEmpty ? 0.0 : total / snapshot.docs.length;
    final ratingData = {'average': average, 'count': snapshot.docs.length};
    _ratingsCache[productId] = ratingData;
    return ratingData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('products').limit(4).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No Products Found");
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final doc = products[index];
            final data = doc.data() as Map<String, dynamic>;
            final imageBytes = base64Decode(data['productImage']);
            final productId = data['productId'];

            return FutureBuilder<Map<String, dynamic>>(
              future: _getRatings(productId),
              builder: (context, ratingSnapshot) {
                double avg = ratingSnapshot.data?['average'] ?? 0.0;
                int count = ratingSnapshot.data?['count'] ?? 0;

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
                          child: Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['productName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(avg.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 13)),
                                Text(' ($count)',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['productDesc'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("PKR ${data['productPrice']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => ProductDetail(productData: data));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    textStyle: const TextStyle(fontSize: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
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
      },
    );
  }
}
