import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) => json.encode(data.toJson());

class UserResponseModel {
  UserResponseModel({
    this.status,
    this.message,
    this.path,
    this.model,
  });

  int? status;
  String? message;
  String? path;
  List<UserModel>? model;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
        status: json["status"],
        message: json["message"],
        path: json["path"],
        model: json["model"] == null ? null : List<UserModel>.from(json["model"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "path": path,
        "model": model == null ? null : List<dynamic>.from(model!.map((x) => x.toJson())),
      };
}

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
