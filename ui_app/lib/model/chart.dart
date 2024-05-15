// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<ChartModel> chartModelFromJson(String str) =>
    List<ChartModel>.from(json.decode(str).map((x) => ChartModel.fromJson(x)));

class ChartModel {
  late int temperature;
  late int humidity;
  late int light;
  late String timestamp;

  ChartModel({
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.timestamp
  });



   factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        temperature: json["temperature"],
        humidity: json["humidity"],
        light: json["light"],
        timestamp: json["timestamp"]
      );

}
