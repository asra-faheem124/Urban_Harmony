class Usermodel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final bool isAdmin;

  Usermodel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'isAdmin': false,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> json) {
    return Usermodel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      isAdmin: json['isAdmin']
    );
  }
}
