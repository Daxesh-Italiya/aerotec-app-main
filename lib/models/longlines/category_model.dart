import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  List<Field> fields;
  String name;
  // Category name;
  // Category partNumber;
  // Category safeWorkingLoad;
  // Category serialNumber;
  // Category timeBetweenOverhauls;
  // Category type;
  // Category length;
  // Category imagePath;
  // Category inspectionDate;
  // Category nextInspectionDate;
  // Category datePurchased;
  // Category datePutIntoService;

  CategoryModel({
    required this.fields,
    required this.name,
    // required this.inspectionDate,
    // required this.nextInspectionDate,
    // required this.partNumber,
    // required this.safeWorkingLoad,
    // required this.serialNumber,
    // required this.timeBetweenOverhauls,
    // required this.type,
    required this.id,
    // required this.name,
    // required this.length,
    // required this.imagePath,
    // required this.datePurchased,
    // required this.datePutIntoService,
  });

  factory CategoryModel.fromSnapshot(DocumentSnapshot document) {
    Map data = document.data() as Map;
    return CategoryModel(
        id: document.id,
        name: data['name'] as String,
        fields: List.generate((data['fields'] as List).length,
            (index) => Field.fromJson(data['fields'][index]))
        // length: data['length'] as String,
        // inspectionDate: data['inspectionDate'] as Timestamp,
        // nextInspectionDate: data['nextInspectionDate'] as Timestamp,
        // partNumber: data['partNumber'] as String,
        // safeWorkingLoad: data['safeWorkingLoad'] as String,
        // serialNumber: data['serialNumber'] as String,
        // timeBetweenOverhauls: data['timeBetweenOverhauls'] as String,
        // type: data['type'] as String,
        // imagePath: data['imagePath'] as String,
        // datePurchased: data['datePurchased'] as Timestamp,
        // datePutIntoService: data['datePutIntoService'] as Timestamp,
        );
  }

  Map toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'fields': List<dynamic>.from(fields.map((x) => x.toJson())),
    };
  }
}

class Field {
  final String name;
  final String type;
  final dynamic options;
  final int position;

  Field(
      {required this.name,
      required this.type,
      required this.options,
      required this.position});

  factory Field.fromJson(Map json) {
    return Field(
      name: json['name'],
      options: json['options'],
      position: json['position'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        "options": options,
        "name": name,
        "position": position,
        "type": type,
      };
}
