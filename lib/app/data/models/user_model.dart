class UserModel {
  String? id;
  String? email;
  String? fullName;
  String? role;

  UserModel({this.id, this.email, this.fullName, this.role});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    role = json['role'];
  }
}
