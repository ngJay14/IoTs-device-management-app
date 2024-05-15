import 'dart:convert';
import 'dart:developer';
import 'package:ui_app/model/board.dart';
import 'package:ui_app/model/chart.dart';
import 'package:ui_app/model/data.dart';
import 'package:ui_app/model/log.dart';
import 'api_constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<BoardModel>?> getBoards() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getBoradsCount);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<BoardModel> model = boardModelFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<DataModel>?> getLastestData() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getLastestData);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<DataModel> model = dataModelFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<LogModel>?> getLogs() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getLogs);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<LogModel> model = logModelFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<ChartModel>?> getCharts() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getCharts);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<ChartModel> model = chartModelFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  void postLightOn(bool light1, bool light2) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.postLightOn);
    
      final msg = jsonEncode({"light1_on":light1,"light2_on":light2});

      http.Response response = await http.post(
          url,
          body: msg,
          headers: <String, String>{
          'Content-Type': 'application/json'}
      );
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}