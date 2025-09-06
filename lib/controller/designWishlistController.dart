import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DesignWishlistController extends GetxController {
  var wishlist = <Map<String, dynamic>>[].obs;

  Future<void> fetchWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final designwishlistSnap = await FirebaseFirestore.instance
        .collection('design_wishlist')
        .where('userId', isEqualTo: user.uid)
        .get();

    List<Map<String, dynamic>> temp = [];

    for (var doc in designwishlistSnap.docs) {
      final did = doc['designId'];

      // Fetch product data
      final designSnap = await FirebaseFirestore.instance
          .collection('design')
          .where('designId', isEqualTo: did)
          .limit(1)
          .get();

      if (designSnap.docs.isNotEmpty) {
        final designData = designSnap.docs.first.data();

        // 🔽 Fetch ratings
        final designratingSnap = await FirebaseFirestore.instance
            .collection('design_ratings')
            .where('designId', isEqualTo: did)
            .get();

        double avgRating = 0;
        int count = designratingSnap.size;

        if (count > 0) {
          avgRating = designratingSnap.docs
              .map((r) => r['rating'] as num)
              .reduce((a, b) => a + b) /
              count;
        }

        // Add dynamic rating info into product map
        designData['averageRating'] = avgRating;
        designData['ratingCount'] = count;

        temp.add(designData);
      }
    }

    wishlist.value = temp;
  }

  Future<void> addToWishlist(String designId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('design_wishlist').add({
      'userId': user.uid,
      'designId': designId,
      'timestamp': Timestamp.now(),
    });

    await fetchWishlist();
  }

  Future<void> removeFromWishlist(String designId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docs = await FirebaseFirestore.instance
        .collection('design_wishlist')
        .where('userId', isEqualTo: user.uid)
        .where('designId', isEqualTo: designId)
        .get();

    for (var doc in docs.docs) {
      await doc.reference.delete();
    }

    await fetchWishlist();
  }

  Future<bool> isInWishlist(String designId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final snap = await FirebaseFirestore.instance
        .collection('design_wishlist')
        .where('userId', isEqualTo: user.uid)
        .where('designId', isEqualTo: designId)
        .get();

    return snap.docs.isNotEmpty;
  }
}
