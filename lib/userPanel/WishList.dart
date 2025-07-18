import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/wishlistController.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class WishList extends StatelessWidget {
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    wishlistController.fetchWishlist(); // Fetch latest on build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        final prodList = wishlistController.wishlist;

        if (prodList.isEmpty) {
          return const Center(
            child: Text("Your wishlist is empty."),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              User_Heading(title: 'My Wishlist'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: prodList.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = prodList[index];
                    final imageBytes = base64Decode(item['productImage']);
                    final avgRating = (item['averageRating'] ?? 0.0).toDouble();
                    final reviewCount = item['ratingCount'] ?? 0;
                
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(imageBytes, width: 80, height: 80, fit: BoxFit.cover),
                      ),
                      title: Text(item['productName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['productDesc']),
                          const SizedBox(height: 4),
                          Text("PKR ${item['productPrice']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: avgRating,
                                itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 16,
                              ),
                              const SizedBox(width: 8),
                              Text("($reviewCount reviews)", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          wishlistController.removeFromWishlist(item['productId']);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
