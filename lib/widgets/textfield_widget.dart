import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String initialValue;
  final onChanged;
  final validator;
  final String labelText;
  final bool obscureText;
  final bool autofocus;
  bool enable;
  final TextCapitalization textCapitalization;
  FocusNode? focusNode;

  TextFieldWidget({
    required this.initialValue,
    required this.onChanged,
    required this.validator,
    required this.labelText,
    required this.obscureText,
    required this.textCapitalization,
    this.enable = true,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: obscureText,
        initialValue: initialValue,
        autofocus: autofocus,
        enabled: enable,
        focusNode: focusNode,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: labelText,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            //errorStyle: TextStyle(color: Colors.red, fontSize: 18),
            labelStyle: TextStyle(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
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
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            isDense: true
            //errorStyle: TextStyle(color: Colors.red)
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
        // Icon(
        //   Icons.drag_indicator,
        //   size: 27,
        //   color: Colors.grey,
        // ),
        Expanded(child: child)
      ],
    );
  }
}
