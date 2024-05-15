// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:ui_app/model/log.dart';
import 'package:ui_app/api/api_services.dart';

List<String> name = [];
List<String> ip = [];
List<int> id = [];
List<String> data = [];
List<String> value = [];
List<String> timestamp = [];

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  LogsState createState() => LogsState();
}

class LogsState extends State<Logs> {
  late List<LogModel>? logModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    logModel = (await ApiService().getLogs())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _setData();
  }

  void _setData() {
  for (var log in logModel!) {
    for (int i in Iterable.generate(3))
    {
        name.add(log.name);
        ip.add(log.ip);
        id.add(log.id);
        timestamp.add(log.timestamp);
    }
    data.add('Temperature');
    data.add('Humidity');
    data.add('Light');

    String temp = log.temperature.toString();
    String hum = log.humidity.toString();
    String light = log.light.toString();

    value.add('$temp°C');
    value.add('$hum%');
    value.add('$light''lux');

    }
  }


  @override
  Widget build(BuildContext context) {
    return logModel == null || logModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
          'System Logs',
        style: TextStyle(
          color: Colors.black,
        ),),
        backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: ListView.builder(
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  return card(name[index], ip[index], id[index], data[index],
                      value[index], timestamp[index], context);
                },
              ),
            ),
          )),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget card(String name, String ip, int id, String data, String value,
      String timestamp, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 100,
        child: Card(
          color: const Color.fromARGB(255, 215, 214, 207),
          elevation: 8.0,
          margin: const EdgeInsets.all(4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                          child: Text(name,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 14, 113, 195),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                          child: Text(ip,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                          child: Text('ID: $id',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 55,
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color: const Color.fromARGB(255, 189, 189, 183),
                      elevation: 2.0,
                      margin: const EdgeInsets.all(4.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              // border color
                              color: Color.fromARGB(255, 67, 64, 64),
                              // border thickness
                              width: 2)),
                      child: Center(
                        child: Text(
                          data,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ),
              ),
              SizedBox(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                          child: Text(
                        timestamp,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
