import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminRatingsPage extends StatelessWidget {
  const AdminRatingsPage({super.key});

  Widget buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index < rating && (rating - index) >= 0.5) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
        }
      }),
    );
  }

  Future<String> fetchProductName(String productId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
      return doc.data()?['productName'] ?? 'Unknown Product';
    } catch (e) {
      return 'Unknown Product';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ratings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No ratings available.'));
          }

          final ratings = snapshot.data!.docs;
          final totalRating = ratings.fold<double>(
            0.0,
            (sum, doc) => sum + (doc['rating']?.toDouble() ?? 0.0),
          );
          final averageRating = totalRating / ratings.length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
             Admin_Heading(title: 'User Ratings'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Average Rating: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  buildRatingStars(averageRating),
                  const SizedBox(width: 6),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ratings List
              ...ratings.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final timestamp = data['timestamp'] as Timestamp?;
                final formattedDate = timestamp != null
                    ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate())
                    : 'N/A';
                final rating = (data['rating'] ?? 0).toDouble();
                final productId = data['productId'] ?? '';

                return FutureBuilder<String>(
                  future: fetchProductName(productId),
                  builder: (context, productSnapshot) {
                    final productName = productSnapshot.data ?? 'Loading...';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.email, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  data['email'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            buildRatingStars(rating),
                            const SizedBox(height: 8),
                            Text(
                              data['review'] ?? '',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList()
            ],
          );
        },
      ),
    );
  }
}
