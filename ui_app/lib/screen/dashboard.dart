import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_app/model/board.dart';
import 'package:ui_app/api/api_services.dart';

const double imageSize = 80;
const double bannerSize = 280;

List<String> images = [];
List<Color> colors = [];

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashBoard> {
  late List<BoardModel>? boardModel = [];
  @override
  void initState() {
    super.initState();
    images = [];
    colors = [];
    _getData();
  }

  void _getData() async {
    boardModel = (await ApiService().getBoards())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _setData();
  }

  void _setData() {
    for (var board in boardModel!) {
      if (board.name == "Wemos D1") {
        images.add('assets/images/wemos.jpg');
      } else {
        images.add('assets/images/rasp_pi.jpg');
      }

      if (board.status == "on") {
        colors.add(const Color.fromARGB(255, 38, 214, 129));
      } else {
        colors.add(const Color.fromARGB(255, 194, 64, 55));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hi My Customers',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: boardModel == null || boardModel!.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  SizedBox(
                    child: SvgPicture.asset(
                      'assets/images/banner.svg',
                      height: bannerSize,
                      width: bannerSize,
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: const <Widget>[
                          Center(
                              child: Text(
                            'Welcome to IoT System Group 6 !',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Center(
                                child: Text(
                              'Member 1: Nguyễn Hữu Nguyên',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Center(
                                child: Text('Member 2: Lê Anh Tài',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ))),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Center(
                                child: Text('Member 3: Lê Việt Tiến',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(child: Text('Devices Controls')),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: boardModel!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return card(
                            images[index],
                            boardModel![index].name,
                            boardModel![index].id,
                            boardModel![index].timestamp,
                            colors[index],
                            context);
                      },
                    ),
                  ),
                ]),
              ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget card(String image, String name, int id, String timestamp, Color color,
      BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 243, 243, 241),
      elevation: 8.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: SizedBox(
                    child: Text(
                      'ID: $id',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.online_prediction,
                          color: color,
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          child: Text(
                            timestamp,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                image,
                height: imageSize,
                width: imageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
