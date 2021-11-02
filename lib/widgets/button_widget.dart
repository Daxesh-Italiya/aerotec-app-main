import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final onPressed;
  final String text;

  const ButtonWidget({ @required required this.onPressed, @required required this.text });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0 ),
          child: Text(text),
        ),
      ),
    );
  }
}
