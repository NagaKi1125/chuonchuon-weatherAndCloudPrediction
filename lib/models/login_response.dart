import 'dart:convert';

LoginUser loginUserFromJson(String str) => LoginUser.fromJson(json.decode(str));

String loginUserToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  LoginUser({
    required this.id,
    required this.name,
    required this.email,
    required this.level,
    required this.updatedAt,
    required this.createdAt,
  });

  String id;
  String name;
  String email;
  int level;
  DateTime updatedAt;
  DateTime createdAt;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    level: json["level"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "level": level,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}
