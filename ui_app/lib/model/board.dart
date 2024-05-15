// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<BoardModel> boardModelFromJson(String str) =>
    List<BoardModel>.from(json.decode(str).map((x) => BoardModel.fromJson(x)));

class BoardModel {
  late String name;
  late int id;
  late String timestamp;
  late String status;

  BoardModel({
    required this.name,
    required this.id,
    required this.timestamp,
    required this.status,
  });

   factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        name: json["name"],
        id: json["id"],
        timestamp: json["timestamp"],
        status: json["status"]
      );

}
