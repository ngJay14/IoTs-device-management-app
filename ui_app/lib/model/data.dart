// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<DataModel> dataModelFromJson(String str) =>
    List<DataModel>.from(json.decode(str).map((x) => DataModel.fromJson(x)));

class DataModel {
  late int temperature;
  late int humidity;
  late int light;

  DataModel({
    required this.temperature,
    required this.humidity,
    required this.light,
  });



   factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        temperature: json["temperature"],
        humidity: json["humidity"],
        light: json["light"],
      );

}
