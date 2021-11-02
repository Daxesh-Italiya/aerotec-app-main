import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LongLinesModel {
  String id;
  String name;
  String partNumber;
  String safeWorkingLoad;
  String serialNumber;
  String timeBetweenOverhauls;
  String type;
  String length;
  String imagePath;
  Timestamp inspectionDate;
  Timestamp nextInspectionDate;
  Timestamp datePurchased;
  Timestamp datePutIntoService;

  LongLinesModel(
      {@required required this.inspectionDate,
      @required required this.nextInspectionDate,
      @required required this.partNumber,
      @required required this.safeWorkingLoad,
      @required required this.serialNumber,
      @required required this.timeBetweenOverhauls,
      @required required this.type,
      @required required this.id,
      @required required this.name,
      @required required this.length,
      @required required this.imagePath,
      @required required this.datePurchased,
      @required required this.datePutIntoService,
  });

  factory LongLinesModel.fromSnapshot(DocumentSnapshot document) {
    Map data = document.data() as Map;
    return LongLinesModel(
      id: document.id,
      name: data['name'] as String,
      length: data['length'] as String,
      inspectionDate: data['inspectionDate'] as Timestamp,
      nextInspectionDate: data['nextInspectionDate'] as Timestamp,
      partNumber: data['partNumber'] as String,
      safeWorkingLoad: data['safeWorkingLoad'] as String,
      serialNumber: data['serialNumber'] as String,
      timeBetweenOverhauls: data['timeBetweenOverhauls'] as String,
      type: data['type'] as String,
      imagePath: data['imagePath'] as String,
      datePurchased: data['datePurchased'] as Timestamp,
      datePutIntoService: data['datePutIntoService'] as Timestamp,
    );
  }
}
