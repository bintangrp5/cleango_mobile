class UserModel {
  String id;
  String email;
  String fullName;
  String role;
  String phoneNumber;
  String address;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber = '',
    this.address = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? 'user',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
