import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/designWishlistController.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/rate_us.dart'; // ✅ reuse same rate page

class DesignDetailPage extends StatefulWidget {
  final Map<String, dynamic> designData;

  const DesignDetailPage({super.key, required this.designData});

  @override
  State<DesignDetailPage> createState() => _DesignDetailPageState();
}

class _DesignDetailPageState extends State<DesignDetailPage> {
  final DesignWishlistController designWishlistController =
      Get.put(DesignWishlistController());

  bool isFav = false;
  double averageRating = 0.0;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    fetchRatings();
    checkIfInWishlist();
  }

  void checkIfInWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isFav = false);
      return;
    }

    final exists = await designWishlistController.isInWishlist(
      widget.designData['designId'],
    );
    setState(() => isFav = exists);
  }

  Future<void> fetchRatings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('design_ratings') // separate collection for designs
        .where('designId', isEqualTo: widget.designData['designId'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      double sum = 0;
      for (var doc in snapshot.docs) {
        sum += doc['rating'];
      }
      setState(() {
        averageRating = sum / snapshot.docs.length;
        totalReviews = snapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(widget.designData["designImage"]);
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Design Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 20),

            // Name + Wishlist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.designData["designName"] ?? "",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      redSnackBar(
                          "❌ Login Required!", "Please login to save designs.");
                      Get.to(Login());
                      return;
                    }

                    if (isFav) {
                      await designWishlistController.removeFromWishlist(
                        widget.designData['designId'],
                      );
                      redSnackBar("Removed", "Design removed from wishlist.");
                    } else {
                      await designWishlistController.addToWishlist(
                        widget.designData['designId'],
                      );
                      greenSnackBar("Added", "Design added to wishlist.");
                    }

                    setState(() => isFav = !isFav);
                  },
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Ratings
            if (totalReviews > 0)
              Row(
                children: [
                  RatingBarIndicator(
                    rating: averageRating,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 22.0,
                  ),
                  const SizedBox(width: 8),
                  Text("($totalReviews Reviews)"),
                ],
              ),

            const SizedBox(height: 20),

            // Description
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              widget.designData["designDesc"] ?? "No description available",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            // Rate Design Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  if (!isLoggedIn) {
                    redSnackBar("Login Required!",
                        "Please login to rate this design.");
                    Get.to(Login());
                    return;
                  }
                  Get.to(() => RateUsPage(id: widget.designData['designId'], isDesign: true));

                },
                icon: const Icon(Icons.rate_review),
                label: const Text("Rate this Design"),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 10),

            const Text(
              "Customer Reviews",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Reviews List
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('design_ratings')
                  .where('designId',
                      isEqualTo: widget.designData['designId'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reviews = snapshot.data!.docs;
                if (reviews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("No reviews yet."),
                  );
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final data =
                        reviews[index].data() as Map<String, dynamic>;
                    final DateTime? timestamp = data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate()
                        : null;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black12,
                        child: const Icon(Icons.person, color: Colors.black),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['email'] ?? 'User',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (timestamp != null)
                            Text(
                              "${timestamp.day}/${timestamp.month}/${timestamp.year}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: (data['rating'] ?? 0).toDouble(),
                            itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 16,
                          ),
                          const SizedBox(height: 4),
                          Text(data['review'] ?? ''),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
