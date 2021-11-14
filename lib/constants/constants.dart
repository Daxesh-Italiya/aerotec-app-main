import 'dart:developer';

import 'package:flutter/material.dart';

List<String> longLineTypes = ['- select -', 'HEC', 'Cargo', 'Short Haul'];
List<String> longLineCategory = [
  '- select or add new  -',
];
List<String> longLineSize = [
  '- select -',
];

List<String> longLineLengths = [
  "- select -",
  "150'",
  "125'",
  "100'",
  "75'",
  "50'",
  "25'"
];

int acc = 0;
List<String> safeWorkingLoadItems = List.generate(16, (i) {
  if (i == 0)
    return '- select -';
  else
    acc = acc + 500;
  return '$acc';
});

List<String> timeBetweenOverhaulsItems = [
  '- select -',
  '90 days',
  '3 months',
  '1 year'
];

class AppTheme {
  static final Color backgroundColor = Color(0xFFf3f3f5);
  static final Color primary = Color(0xFF0e2b5b);
  static final Color secondary = Color(0xFF0c77ff);
  static final Color appBarFont = Color(0xFF77afc4);
}

extension Log on String {
  logString(String name) {
    log(this, name:name);
  }
}
