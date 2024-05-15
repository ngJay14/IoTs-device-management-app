import 'package:flutter/material.dart';

class HumRoom extends StatelessWidget {
  const HumRoom(this.humidity, {super.key});

  final int humidity;

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
                  'Humidity Room',
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
                color: Colors.blue[100], // border color
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$humidity%',
                    style: const TextStyle(
                      color: Colors.blue,
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