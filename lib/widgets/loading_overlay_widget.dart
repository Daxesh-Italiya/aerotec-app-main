import 'package:flutter/material.dart';
class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        child: Center(child: CircularProgressIndicator(),
      ),
    );
  }
}
