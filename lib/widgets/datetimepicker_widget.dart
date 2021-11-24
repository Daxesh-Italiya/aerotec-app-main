import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerWidget extends StatelessWidget {
  final DateFormat format;
  final onChanged;
  final validator;
  final DateTime? initialValue;
  final String labelText;

  DateTimePickerWidget({
    Key? key,
    required this.format,
    required this.onChanged,
    required this.initialValue,
    required this.labelText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 55,
      child: DateTimeField(
        validator: validator,
        format: format,
        onChanged: onChanged,
        initialValue: initialValue,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: TextStyle(),
          fillColor: Colors.white,
          suffixIcon: Icon(Icons.calendar_today_sharp),
          hintText: 'Select Date',
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            initialDate: currentValue ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
        },
      ),
    );
  }
}

class ReorderableDateTimePickerWidget extends StatelessWidget {
  final Widget child;

  ReorderableDateTimePickerWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(
        //   Icons.drag_indicator,
        //   size: 27,
        //   color: Colors.grey,
        // ),
        Expanded(
          child: child,
        )
      ],
    );
  }
}
