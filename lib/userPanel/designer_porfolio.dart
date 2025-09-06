import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Designers_Portfolio extends StatefulWidget {
  const Designers_Portfolio({super.key});

  @override
  State<Designers_Portfolio> createState() => _Designers_PortfolioState();
}

class _Designers_PortfolioState extends State<Designers_Portfolio> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllDesignersWithPortfolio() async {
    final snapshot = await FirebaseFirestore.instance.collection("User").get();

    List<Map<String, dynamic>> designers = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data["portfolio"] != null && (data["portfolio"] as List).isNotEmpty) {
        designers.add({...data, "id": doc.id});
      }
    }
    return designers;
  }

  Future<void> _addReview(String designerId, String projectTitle) async {
    TextEditingController reviewController = TextEditingController();
    double rating = 3.0;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text("Add Review for $projectTitle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: rating,
                onChanged: (val) {
                  setStateDialog(() => rating = val);
                },
                divisions: 5,
                min: 1,
                max: 5,
                label: rating.toString(),
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(hintText: "Your Review"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (reviewController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your review")),
                  );
                  return;
                }

                EasyLoading.show(status: 'Submitting...');
                try {
                  final userDoc = await _firestore
                      .collection("User")
                      .doc(currentUser?.uid)
                      .get();

                  final userName = userDoc.data()?['name'] ?? "Anonymous";

                  await _firestore
                      .collection("User")
                      .doc(designerId)
                      .collection("reviews")
                      .add({
                    "userName": userName,
                    "rating": rating,
                    "reviewText": reviewController.text.trim(),
                    "createdAt": DateTime.now().toIso8601String(),
                    "projectTitle": projectTitle,
                  });

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Review added successfully!")),
                  );
                } catch (e) {
                  print("Error adding review: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                } finally {
                  EasyLoading.dismiss();
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviews(String designerId, String projectTitle) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("User")
          .doc(designerId)
          .collection("reviews")
          .where("projectTitle", isEqualTo: projectTitle)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No reviews yet."),
          );
        }

        final reviews = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reviews.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(data["userName"] ?? "Anonymous"),
              subtitle: Text(data["reviewText"] ?? ""),
              trailing: Text("${data["rating"] ?? 0}⭐"),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Designers Portfolio")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllDesignersWithPortfolio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No portfolios available"));
          }

          final designers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: designers.length,
            itemBuilder: (context, index) {
              final designer = designers[index];
              final portfolio = designer["portfolio"] as List;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        designer["name"] ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...portfolio.map((work) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (work["imageUrl"] != null)
                              Image.network(
                                work["imageUrl"],
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            Text(
                              "Title: ${work["title"] ?? "No title"}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text("Description: ${work["description"] ?? ""}"),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    _addReview(designer["id"], work["title"]),
                                child: const Text("Send Review"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildReviews(designer["id"], work["title"]),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
