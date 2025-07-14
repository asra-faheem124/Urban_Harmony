class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryImage: json['categoryImage']
    );
  }
}
