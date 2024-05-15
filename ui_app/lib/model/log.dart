// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<LogModel> logModelFromJson(String str) =>
    List<LogModel>.from(json.decode(str).map((x) => LogModel.fromJson(x)));

class LogModel {
  late String name;
  late String ip;
  late int id;
  late String temperature;
  late String humidity;
  late String light;
  late String timestamp;

  LogModel({
    required this.name,
    required this.ip,
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.timestamp,
  });


   factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        name: json["name"],
        ip: json["ip"],
        id: json["id"],
        temperature: json["data"]["temperature"].toString(),
        humidity: json["data"]["humidity"].toString(),
        light: json["data"]["light"].toString(),
        timestamp: json["timestamp"]
      );

}
