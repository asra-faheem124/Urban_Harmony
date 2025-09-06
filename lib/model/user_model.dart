class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String role; // "user", "designer", "admin"
  


  final String? bio;
  final String? profilePic;
  final List<Map<String, dynamic>>? portfolio;   // list of projects
  final List<Map<String, dynamic>>? availability; // available slots

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
    this.bio,
    this.profilePic,
    this.portfolio,
    this.availability,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'bio': bio,
      'profilePic': profilePic,
      'portfolio': portfolio,
      'availability': availability,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    phoneNumber: json['phoneNumber'],
    role: json['role'] ?? 'user', // default to 'user' if missing
    bio: json['bio'],
    profilePic: json['profilePic'],
    portfolio: (json['portfolio'] != null)
        ? List<Map<String, dynamic>>.from(json['portfolio'])
        : [],
    availability: (json['availability'] != null)
        ? List<Map<String, dynamic>>.from(json['availability'])
        : [],
  );
}

}
