import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ComponentsModel {
  String id;
  String name;
  String category; // Dropdown
  String description;
  String partNumber;
  String safeWorkingLoad; // Dropdown
  String serialNumber;
  String timeBetweenOverhauls;
  String imagePath; // Dropdown
  Timestamp datePurchased;
  Timestamp datePutIntoService;
  Timestamp inspectionDate;
  Timestamp nextInspectionDate;

  ComponentsModel({
      @required required this.id,
      @required required this.name,
      @required required this.category,
      @required required this.description,
      @required required this.partNumber,
      @required required this.safeWorkingLoad,
      @required required this.serialNumber,
      @required required this.timeBetweenOverhauls,
      @required required this.imagePath,
      @required required this.datePurchased,
      @required required this.datePutIntoService,
      @required required this.inspectionDate,
      @required required this.nextInspectionDate
  });

  factory ComponentsModel.fromSnapshot(DocumentSnapshot document) {
    Map data = document.data() as Map;
    return ComponentsModel(
      id: document.id,
      name: data['name'] as String,
      category: data['category'] as String,
      description: data['description'] as String,
      partNumber: data['partNumber'] as String,
      safeWorkingLoad: data['safeWorkingLoad'] as String,
      serialNumber: data['serialNumber'] as String,
      timeBetweenOverhauls: data['timeBetweenOverhauls'] as String,
      imagePath: data['imagePath'] as String,
      inspectionDate: data['inspectionDate'] as Timestamp,
      nextInspectionDate: data['nextInspectionDate'] as Timestamp,
      datePurchased: data['datePurchased'] as Timestamp,
      datePutIntoService: data['datePutIntoService'] as Timestamp,
    );
  }
}
