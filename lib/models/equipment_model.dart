import 'package:aerotec_flutter_app/models/field_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EquipmentModel {
  String id;
  Map fields;

  EquipmentModel({
    @required required this.id,
    @required required this.fields,
  });

  factory EquipmentModel.fromSnapshot(DocumentSnapshot document) {
    Map data = document.data() as Map;

    Map<String, dynamic> fields = {};
    data.forEach((key, value) {
      fields[key] = value;
    });

    return EquipmentModel(
      id: document.id,
      fields: fields,
    );
  }

  factory EquipmentModel.fromAllfields(allFields) {

    var fields = {};
    allFields.forEach((Field field) {
      if (field.type == 'date') {
        fields[field.name] = field.date;
      } else {
        fields[field.name] = field.value;
      }
    });

    return EquipmentModel(
      id: "0",
      fields: fields,
    );
  }
}
