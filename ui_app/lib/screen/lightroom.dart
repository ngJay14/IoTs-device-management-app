import 'package:flutter/material.dart';

class LightRoom extends StatelessWidget {
  const LightRoom(this.light, {super.key});

  final int light;

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
                  'Light Room',
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
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100], // border color
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$light',
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'lux',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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