import 'package:flutter/material.dart';
import 'package:ui_app/screen/logs.dart';
import 'package:ui_app/screen/devices.dart';
import 'package:ui_app/screen/dashboard.dart';
import 'package:ui_app/screen/charts.dart';
// import 'package:ui_app/test.dart';

class Template extends StatefulWidget{
  const Template({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }

}

class _MainState extends State<Template>{
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index){
            setState(() {
            _currentIndex = index;
  });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Devices',),
          BottomNavigationBarItem(icon: Icon(Icons.power_settings_new_outlined), label:  ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Charts'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Logs')
        ],
        currentIndex: _currentIndex,

      ),
      body: getBodyWidget(),
    );
  }

  getBodyWidget() {
    switch(_currentIndex) {
            case 0: return const DashBoard();
            case 1: return const Devices();
            case 3: return const Charts();
            case 4: return const Logs();
        }  
      }  
    }
