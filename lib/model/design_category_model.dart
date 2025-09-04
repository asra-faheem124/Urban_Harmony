class DesignCategoryModel {
  final String categoryId;
  final String categoryName;

  DesignCategoryModel({
    required this.categoryId,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  factory DesignCategoryModel.fromMap(Map<String, dynamic> json) {
    return DesignCategoryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }
}
