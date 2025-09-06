import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class DesignerPortfolioScreen extends StatefulWidget {
  final String designerId;
  const DesignerPortfolioScreen({super.key, required this.designerId});

  @override
  State<DesignerPortfolioScreen> createState() =>
      _DesignerPortfolioScreenState();
}

class _DesignerPortfolioScreenState extends State<DesignerPortfolioScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String?> encodeImageToBase64(XFile file) async {
    try {
      Uint8List bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("Error encoding image: $e");
      return null;
    }
  }

  Future<void> addProject() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    XFile? pickedImage;
    bool imageSelected = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Add Project"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Project Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    pickedImage = image;
                    setStateDialog(() {
                      imageSelected = true;
                    });
                  }
                },
                child: Text(imageSelected ? "Image Selected" : "Pick Image"),
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
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    pickedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Please fill all fields and select an image")),
                  );
                  return;
                }

                EasyLoading.show(status: 'Saving...');
                try {
                  String? base64Image = await encodeImageToBase64(pickedImage!);
                  if (base64Image == null) throw Exception("Image encoding failed");

                  await _firestore
                      .collection("User")
                      .doc(widget.designerId)
                      .set({
                    "portfolio": FieldValue.arrayUnion([
                      {
                        "title": titleController.text.trim(),
                        "description": descriptionController.text.trim(),
                        "imageData": base64Image,
                        "createdAt": DateTime.now().toIso8601String(),
                      }
                    ]),
                  }, SetOptions(merge: true));

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Project added successfully!")),
                  );
                } catch (e) {
                  print("Error adding project: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                } finally {
                  EasyLoading.dismiss();
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addProjectReview(String projectTitle) async {
    TextEditingController nameController = TextEditingController();
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Your Name"),
              ),
              const SizedBox(height: 10),
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
                if (nameController.text.isEmpty ||
                    reviewController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                EasyLoading.show(status: 'Submitting...');
                try {
                  await _firestore
                      .collection("User")
                      .doc(widget.designerId)
                      .collection("reviews")
                      .add({
                    "userName": nameController.text.trim(),
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

  Widget _buildProjectReviews(String projectTitle) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("User")
          .doc(widget.designerId)
          .collection("reviews")
          .where("projectTitle", isEqualTo: projectTitle)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No reviews yet for this project");
        }

        final reviews = snapshot.data!.docs;
        double avgRating = reviews
                .map((doc) => (doc['rating'] as num).toDouble())
                .fold(0.0, (sum, rating) => sum + rating) /
            reviews.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("⭐ Avg Rating: ${avgRating.toStringAsFixed(1)}"),
            ...reviews.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data["userName"] ?? "Anonymous"),
                subtitle: Text(data["reviewText"] ?? ""),
                trailing: Text("${data["rating"] ?? 0}⭐"),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildPortfolioSection() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection("User").doc(widget.designerId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No projects added yet"));
        }

        var userData = snapshot.data!.data()! as Map<String, dynamic>;
        List portfolio = userData['portfolio'] ?? [];

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: portfolio.length,
          itemBuilder: (context, index) {
            var project = portfolio[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: project['imageData'] != null
                          ? Image.memory(
                              base64Decode(project['imageData']),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image),
                      title: Text(project['title'] ?? "No Title"),
                      subtitle: Text(project['description'] ?? "No Description"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteProject(project),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            addProjectReview(project['title'] ?? "Unknown"),
                        child: const Text("Add Review"),
                      ),
                    ),
                    _buildProjectReviews(project['title'] ?? "Unknown"),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteProject(Map<String, dynamic> project) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      await _firestore.collection("User").doc(widget.designerId).update({
        "portfolio": FieldValue.arrayRemove([project]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project deleted successfully!")),
      );
    } catch (e) {
      print("Error deleting project: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Portfolio"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: addProject),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Portfolio",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildPortfolioSection(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Designer Reviews",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildReviewsSection(), // Keep your general reviews section
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("User")
          .doc(widget.designerId)
          .collection("reviews")
          .where("projectTitle", isNull: true) // Only designer-level reviews
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No designer reviews yet");
        }

        final reviews = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                child: Text("${review["rating"] ?? 0}⭐"),
              ),
              title: Text(review["userName"] ?? "Anonymous"),
              subtitle: Text(review["reviewText"] ?? ""),
            );
          },
        );
      },
    );
  }
}
