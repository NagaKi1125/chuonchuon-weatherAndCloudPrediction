
import 'dart:convert';

RegisterUser registerUserFromJson(String str) => RegisterUser.fromJson(json.decode(str));

String registerUserToJson(RegisterUser data) => json.encode(data.toJson());

class RegisterUser {
  RegisterUser({
    required this.name,
    required this.email,
    required this.level,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String name;
  String email;
  int level;
  DateTime updatedAt;
  DateTime createdAt;
  String id;

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    name: json["name"],
    email: json["email"],
    level: json["level"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "level": level,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "_id": id,
  };
}
