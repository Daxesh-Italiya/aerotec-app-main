import 'package:flutter/material.dart';

class Field {
  String? label;
  String? name;
  String? type;
  List<dynamic> options = [];
  int? position;
  String? value;

  Widget? widget;
  String? mainType;
  bool? removed;
  bool? isOptional = false;

  DateTime? date;

  Field({
    required this.label,
    required this.name,
    required this.type,
    required this.options,
    required this.position,
    this.widget,
    this.mainType,
    this.removed,
    this.date,
    this.value,
    this.isOptional,
  });

  factory Field.fromJson(Map json) {
    return Field(
      label: json['label'],
      name: json['name'],
      options: json['options'],
      position: json['position'],
      type: json['type'],
      value: json['value'],
      mainType: json['main_type'] ?? "other",
      isOptional: json['is_optional'],
    );
  }
}
