class designModel {
  final String designId;
  final String designName;
  final String designDesc;
  final String designCategory; // new
  final String designImage;

  designModel({
    required this.designId,
    required this.designName,
    required this.designDesc,
    required this.designCategory,
    required this.designImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'designId': designId,
      'designName': designName,
      'designDesc': designDesc,
      'designCategory': designCategory,
      'designImage': designImage,
    };
  }

  // fromMap is defensive: uses default values if keys are missing
  factory designModel.fromMap(Map<String, dynamic> json) {
    return designModel(
      designId: json['designId']?.toString() ?? '',
      designName: json['designName']?.toString() ?? '',
      designDesc: json['designDesc']?.toString() ?? '',
      designCategory: json['designCategory']?.toString() ?? 'All',
      designImage: json['designImage']?.toString() ?? '',
    );
  }
}
