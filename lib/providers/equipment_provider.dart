import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:aerotec_flutter_app/services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/equipment_model.dart';

class GroupEquipment {
  late String categoryName;
  late List<EquipmentModel> equipmentList = [];
}

class EquipmentProvider extends ChangeNotifier {
  List<EquipmentModel> _equipmentList = [];
  List<GroupEquipment> _groupEquipmentList = [];
  // late EquipmentModel _singleListing;
  bool _isLoading = false;
  StreamSubscription? subscription;

  bool get isLoading => _isLoading;

  List<GroupEquipment> get groupEquipments => _groupEquipmentList;

  List<EquipmentModel> get equipmentList => _searchString.isEmpty
      ? UnmodifiableListView(_equipmentList)
      : UnmodifiableListView(_equipmentList.where((element) =>
          element.fields['name'].toString().toLowerCase().contains(_searchString.toLowerCase())));

  String _searchString = "";

  void changeSearchString(String searchString) {
    _searchString = searchString;
    notifyListeners();
  }

  void loading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  subData() {
    subscription?.cancel();
    subscription = FirebaseFirestore.instance
        .collection('aerotec/equipment/equipment')
        .snapshots()
        .listen(getData);
  }

  getData(snapshot) {
    _equipmentList.clear();
    _groupEquipmentList.clear();

    snapshot.docs.forEach((DocumentSnapshot document) {
      EquipmentModel equipmentModel = EquipmentModel.fromSnapshot(document);
      _equipmentList.add(equipmentModel);
    });

    List<String> categories = [];
    List<GroupEquipment> finalResult = [];

    for (var equip in _equipmentList) {
      if (equip.fields.containsKey('category_name')) {
        String categoryName = equip.fields['category_name'];

        // Category exist, append in old list
        if (categories.contains(categoryName)) {
          GroupEquipment temp =
              finalResult.firstWhere((element) => element.categoryName == categoryName);
          temp.equipmentList.add(equip);
        } else {
          // New category, append in new list
          categories.add(categoryName);

          GroupEquipment temp = GroupEquipment();
          temp.categoryName = categoryName;
          temp.equipmentList.add(equip);

          finalResult.add(temp);
        }
      }
    }
    // Uniue array list...
    print('Categories Length = ${categories.length}');
    print('Final Length = ${finalResult}');

    _groupEquipmentList.addAll(finalResult);

    loading(false);
  }

  /* UPDATE LISTING ----------------------------------------------------------------*/

  updateListing(EquipmentModel equipment, [String? category_id, File? image]) async {
    loading(true);
    CollectionReference equipmentRef =
        FirebaseFirestore.instance.collection('aerotec/equipment/equipment');
    if (image != null) {
      String fileUrl = await ImageService.upload(image, 'aerotec/equipment',
          equipment.id + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
      equipment.fields['filename'] = fileUrl;
    }
    if (category_id != null) equipment.fields['category_id'] = category_id;

    Map<String, dynamic> record = {};
    equipment.fields.forEach((key, value) {
      record[key] = value;
    });

    return equipmentRef.doc(equipment.id).update(record).then((value) {
      loading(false);
    });
  }

  /* CREATE LISTING ----------------------------------------------------------------*/

  Future createNewListing(EquipmentModel equipment, String id, String name, File? image) async {
    loading(true);
    DocumentReference equipmentRef =
        FirebaseFirestore.instance.collection('aerotec/equipment/equipment').doc();
    print(equipmentRef.id);

    if (image != null) {
      String fileUrl =
          await ImageService.upload(image, 'aerotec/equipment', equipmentRef.id + '.jpg');
      equipment.fields['filename'] = fileUrl;
    }
    equipment.fields['category_id'] = id;
    equipment.fields['category_name'] = name;

    Map<String, dynamic> record = {};
    equipment.fields.forEach((key, value) {
      record[key] = value;
    });

    return equipmentRef.set(record).then((value) {
      try {
        Fluttertoast.showToast(
            msg: "Equipment Saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        log(e.toString());
      }
      loading(false);
    });
  }
}
