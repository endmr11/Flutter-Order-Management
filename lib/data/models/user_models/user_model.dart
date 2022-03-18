import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.userId,
    this.userName,
    this.userSurname,
    this.userEmail,
    this.userType,
  });

  int? userId;
  String? userName;
  String? userSurname;
  String? userEmail;
  int? userType;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        userName: json["user_name"],
        userSurname: json["user_surname"],
        userEmail: json["user_email"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_surname": userSurname,
        "user_email": userEmail,
        "user_type": userType,
      };
}
