import 'dart:convert';

CloudPredictResult cloudPredictResultFromJson(String str) => CloudPredictResult.fromJson(json.decode(str));

String cloudPredictResultToJson(CloudPredictResult data) => json.encode(data.toJson());

class CloudPredictResult {
  CloudPredictResult({
    required this.cloudName,
    required this.cloudCode,
    required this.structure,
    required this.weather,
    required this.note,
    required this.img,
    required this.message,
  });

  String cloudName;
  String cloudCode;
  String structure;
  String weather;
  String note;
  String img;
  String message;

  factory CloudPredictResult.fromJson(Map<String, dynamic> json) => CloudPredictResult(
    cloudName: json["cloud_name"],
    cloudCode: json["cloud_code"],
    structure: json["structure"],
    weather: json["weather"],
    note: json["note"],
    img: json["img"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "cloud_name": cloudName,
    "cloud_code": cloudCode,
    "structure": structure,
    "weather": weather,
    "note": note,
    "img": img,
    "message": message,
  };
}
