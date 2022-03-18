import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.token,
    this.userGroup,
  });

  int? id;
  String? name;
  String? surname;
  String? email;
  String? token;
  int? userGroup;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        token: json["token"],
        userGroup: json["user_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "token": token,
        "user_group": userGroup,
      };
}
