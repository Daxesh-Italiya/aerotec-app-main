import 'package:flutter/material.dart';

class PlatformScreen extends StatefulWidget {
  @override
  _PlatformScreen createState() => _PlatformScreen();
}

class _PlatformScreen extends State<PlatformScreen> {
  bool? value1 = false;
  bool? value2 = false;
  bool? value3 = false;
  bool? value4 = false;
  bool? value5 = false;
  bool? value6 = false;
  bool? value7 = false;
  bool? value8 = false;
  bool? value9 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Text(
              "Platforms",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      )
    );
  }
}
