class ProductModel {
  final String productId;
  final String productName;
  final String productDesc;
  final String productPrice;
  final String productImage;
  final String categoryId;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productDesc,
    required this.productPrice,
    required this.productImage,
    required this.categoryId
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productDesc': productDesc,
      'productPrice': productPrice,
      'productImage': productImage,
      'categoryId': categoryId,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      productName: json['productName'],
      productDesc: json['productDesc'],
      productPrice: json['productPrice'],
      productImage: json['productImage'],
      categoryId: json['categoryId'],
    );
  }
}
