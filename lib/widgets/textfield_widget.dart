import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String initialValue;
  final onChanged;
  final validator;
  final String labelText;
  final bool obscureText;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  TextFieldWidget({
    required this.initialValue,
    required this.onChanged,
    required this.validator,
    required this.labelText,
    required this.obscureText,
    required this.textCapitalization,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextFormField(
        obscureText: obscureText,
        initialValue: initialValue,
        autofocus: autofocus,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: TextStyle(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          )),
          fillColor: Colors.white,
          filled: true,
        ),
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class ReorderableTextFieldWidget extends StatelessWidget {
  final TextFieldWidget child;

  ReorderableTextFieldWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.drag_indicator,
          size: 27,
          color: Colors.grey,
        ),
        Expanded(child: child)
      ],
    );
  }
}
