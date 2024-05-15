// main.dart
// ignore_for_file: non_constant_identifier_names

import 'package:ui_app/model/data.dart';
import 'package:ui_app/api/api_services.dart';

import 'package:flutter/material.dart';
import 'package:ui_app/screen/temproom.dart';
import 'package:ui_app/screen/humroom.dart';
import 'package:ui_app/screen/lightroom.dart';

int _currentIndex = 0;
bool light1_on = false;
bool light2_on = false;

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  DevicesState createState() => DevicesState();
}

class DevicesState extends State<Devices> {
  late List<DataModel>? dataModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    dataModel = (await ApiService().getLastestData())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _postLighton() async{
    ApiService().postLightOn(light1_on, light2_on);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Control Your Devices',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (_currentIndex == 2) {
                    _currentIndex = 0;
                    return;
                  }
                  _currentIndex++;
                });
              },
              style: IconButton.styleFrom(
                  minimumSize: const Size(20, 20),
                  padding: const EdgeInsets.symmetric(horizontal: 4)),
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              height: 250,
              width: double.infinity,
              child: dataModel == null || dataModel!.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : getWidget(dataModel![0].temperature, dataModel![0].humidity, dataModel![0].light),
            ),
            const SizedBox(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Text(
                      'Devices',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                if (light1_on == false)
                                {
                                  light1_on = true;
                                  _postLighton();
                                }
                                else
                                {
                                  light1_on = false;
                                  _postLighton();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15),
                                backgroundColor: Colors.yellow[200],
                              ),
                              child: const Icon(
                                Icons.light_mode_outlined,
                                color: Colors.black45,
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Light 1',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                if (light2_on == false)
                                {
                                  light2_on = true;
                                  _postLighton();
                                }
                                else
                                {
                                  light2_on = false;
                                  _postLighton();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15),
                                backgroundColor: Colors.cyan[200],
                              ),
                              child: const Icon(
                                Icons.light_mode_outlined,
                                color: Colors.black45,
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Light 2',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

getWidget(int temperature, int humidity, int light) {
  switch (_currentIndex) {
    case 0:
      return TempRoom(temperature);
    case 1:
      return HumRoom(humidity);
    case 2:
      return LightRoom(light);
  }
}
