import 'package:aerotec_flutter_app/models/field_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  String? id;
  String name;
  List<Field> fields;

  CategoryModel({
    required this.id,
    required this.name,
    required this.fields,
  });

  factory CategoryModel.fromSnapshot(DocumentSnapshot document) {
    Map data = document.data() as Map;
    return CategoryModel(
      id: document.id,
      name: data['name'] as String,
      fields: List.generate((data['fields'] as List).length, (index) => Field.fromJson(data['fields'][index]))
    );
  }
}