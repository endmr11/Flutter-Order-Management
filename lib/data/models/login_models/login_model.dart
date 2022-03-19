// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    this.status,
    this.message,
    this.path,
    this.model,
  });

  int? status;
  String? message;
  String? path;
  List<LoginModel>? model;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        status: json["status"],
        message: json["message"],
        path: json["path"],
        model: json["model"] == null ? null : List<LoginModel>.from(json["model"].map((x) => LoginModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "path": path,
        "model": model == null ? null : List<dynamic>.from(model!.map((x) => x.toJson())),
      };
}

class LoginModel {
  LoginModel({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.token,
    this.userType,
  });

  int? id;
  String? name;
  String? surname;
  String? email;
  String? token;
  int? userType;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        token: json["token"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "token": token,
        "user_type": userType,
      };
}
