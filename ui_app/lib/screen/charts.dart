// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_app/model/chart.dart';
import 'package:ui_app/api/api_services.dart';

List<String> name = ['Temerature', 'Humidity', 'Light'];
List<double> y_axis_temp = [];
List<double> y_axis_hum = [];
List<double> y_axis_light = [];
List<double> x_axis = [];
List<String> x_title = [];
List listSpots = [];

List<Color> chartColors = [Colors.red, Colors.blue, Colors.yellow];

DateTime now = DateTime.now();
DateFormat formatter = DateFormat('dd-MM-yyyy');
String time_formatted = formatter.format(now);

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  ChartsState createState() => ChartsState();
}

class ChartsState extends State<Charts> {
  late List<ChartModel>? chartModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    chartModel = (await ApiService().getCharts())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _setData();
  }

  void _setData() {
    int count = 0;
    for (var chart in chartModel!) {
      y_axis_temp.add(chart.temperature.toDouble());
      y_axis_hum.add(chart.humidity.toDouble());
      y_axis_light.add(chart.light.toDouble());
      x_axis.add(count.toDouble());
      x_title.add(chart.timestamp);
      count += 1;
    }
  }

  List getSpots() {
    List<FlSpot> temp_spots = [];
    List<FlSpot> hum_spots = [];
    List<FlSpot> light_spots = [];
    for (int i = 0; i < x_axis.length; i++) {
      FlSpot tempSpot = FlSpot(x_axis[i], y_axis_temp[i]);
      FlSpot humSpot = FlSpot(x_axis[i], y_axis_hum[i]);
      FlSpot lightSpot = FlSpot(x_axis[i], y_axis_light[i]);

      temp_spots.add(tempSpot);
      hum_spots.add(humSpot);
      light_spots.add(lightSpot);
    }
    listSpots.addAll([temp_spots, hum_spots, light_spots]);

    return listSpots;
  }

  @override
  Widget build(BuildContext context) {
    return chartModel == null || chartModel!.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Visualize Your Data ($time_formatted)',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return chart(name[index], getSpots()[index],
                            chartColors[index], context);
                      },
                    ),
                  ),
                )),
            debugShowCheckedModeBanner: false,
          );
  }

  Widget chart(
      String name, List<FlSpot> spots, Color chartColor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
                child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10),
            child: SizedBox(
              height: 400,
              width: double.infinity,
              child: LineChart(LineChartData(
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // The red line
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    color: chartColor,
                  ),
                ],
                lineTouchData: LineTouchData(enabled: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(x_title[value.toInt()]);
                    },
                  )),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: false,
                  )),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: false,
                  )),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
