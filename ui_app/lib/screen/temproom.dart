import 'package:flutter/material.dart';

class TempRoom extends StatelessWidget {
  const TempRoom(this.tempvalue, {super.key});

  final int tempvalue;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Temperature Room',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              width: 200,
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
              decoration: BoxDecoration(
                color: Colors.red[100], // border color
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$tempvalue°C',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}