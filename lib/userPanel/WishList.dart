import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/designWishlistController.dart';
import 'package:laptop_harbor/controller/wishlistController.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class WishList extends StatelessWidget {
  final WishlistController wishlistController = Get.put(WishlistController());
  final DesignWishlistController designWishlistController =Get.put(DesignWishlistController());

  @override
  Widget build(BuildContext context) {
    // Fetch both product + design wishlists
    wishlistController.fetchWishlist();
    designWishlistController.fetchWishlist();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Obx(() {
        final prodList = wishlistController.wishlist;
        final designList = designWishlistController.wishlist;

        if (prodList.isEmpty && designList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 50,
                  child: Icon(Icons.favorite, size: 50, color: Colors.black),
                ),
                SizedBox(height: 20),
                Text(
                  "Your wishlist is empty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              User_Heading(title: 'My Wishlist'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    /// Products Section
                    if (prodList.isNotEmpty) ...[
                      const Text(
                        "Products",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...prodList.map((item) {
                        final imageBytes =
                            base64Decode(item['productImage']);
                        final avgRating =
                            (item['averageRating'] ?? 0.0).toDouble();
                        final reviewCount = item['ratingCount'] ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                imageBytes,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['productName'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['productDesc']),
                                const SizedBox(height: 4),
                                Text(
                                  "PKR ${item['productPrice']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: avgRating,
                                      itemBuilder: (_, __) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "($reviewCount reviews)",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                wishlistController.removeFromWishlist(
                                    item['productId']);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                    ],

                    /// Designs Section
                    if (designList.isNotEmpty) ...[
                      const Text(
                        "Designs",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...designList.map((item) {
                        final imageBytes =
                            base64Decode(item['designImage']);
                        final avgRating =
                            (item['averageRating'] ?? 0.0).toDouble();
                        final reviewCount = item['ratingCount'] ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                imageBytes,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['designName'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['designDesc']),
                                const SizedBox(height: 4),
                                Text(
                                  "PKR ${item['designPrice']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: avgRating,
                                      itemBuilder: (_, __) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "($reviewCount reviews)",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                designWishlistController.removeFromWishlist(
                                    item['designId']);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
