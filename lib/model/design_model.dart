class designModel {
  final String designId;
  final String designName;
  final String designDesc;
  
  final String designImage;

  designModel({
    required this.designId,
    required this.designName,
    required this.designDesc,

    required this.designImage,
   
  });

  Map<String, dynamic> toMap() {
    return {
      'designId': designId,
      'designName': designName,
      'designDesc': designDesc,
      
      'designImage': designImage,
      
    };
  }

  factory designModel.fromMap(Map<String, dynamic> json) {
    return designModel(
      designId: json['designId'],
      designName: json['designName'],
      designDesc: json['designDesc'],

      designImage: json['designImage'],
      
    );
  }
}
