import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  var wishlist = <Map<String, dynamic>>[].obs;

  Future<void> fetchWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final wishlistSnap = await FirebaseFirestore.instance
        .collection('wishlists')
        .where('userId', isEqualTo: user.uid)
        .get();

    List<Map<String, dynamic>> temp = [];

    for (var doc in wishlistSnap.docs) {
      final pid = doc['productId'];

      // Fetch product data
      final prodSnap = await FirebaseFirestore.instance
          .collection('products')
          .where('productId', isEqualTo: pid)
          .limit(1)
          .get();

      if (prodSnap.docs.isNotEmpty) {
        final prodData = prodSnap.docs.first.data();

        // 🔽 Fetch ratings
        final ratingSnap = await FirebaseFirestore.instance
            .collection('ratings')
            .where('productId', isEqualTo: pid)
            .get();

        double avgRating = 0;
        int count = ratingSnap.size;

        if (count > 0) {
          avgRating = ratingSnap.docs
              .map((r) => r['rating'] as num)
              .reduce((a, b) => a + b) /
              count;
        }

        // Add dynamic rating info into product map
        prodData['averageRating'] = avgRating;
        prodData['ratingCount'] = count;

        temp.add(prodData);
      }
    }

    wishlist.value = temp;
  }

  Future<void> addToWishlist(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('wishlists').add({
      'userId': user.uid,
      'productId': productId,
      'timestamp': Timestamp.now(),
    });

    await fetchWishlist();
  }

  Future<void> removeFromWishlist(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docs = await FirebaseFirestore.instance
        .collection('wishlists')
        .where('userId', isEqualTo: user.uid)
        .where('productId', isEqualTo: productId)
        .get();

    for (var doc in docs.docs) {
      await doc.reference.delete();
    }

    await fetchWishlist();
  }

  Future<bool> isInWishlist(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final snap = await FirebaseFirestore.instance
        .collection('wishlists')
        .where('userId', isEqualTo: user.uid)
        .where('productId', isEqualTo: productId)
        .get();

    return snap.docs.isNotEmpty;
  }
}
