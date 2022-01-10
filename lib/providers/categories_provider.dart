import 'dart:async';

import 'package:aerotec_flutter_app/models/category_model.dart';
import 'package:aerotec_flutter_app/models/field_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  StreamSubscription? subscription;

  bool get isLoading => _isLoading;
  List<CategoryModel> get categories => _categories;

  void loading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  subData() {
    subscription?.cancel();
    subscription = FirebaseFirestore.instance.collection('aerotec/categories/categories').snapshots().listen(getData);
  }

  getData(snapshot) {
    _categories.clear();
    snapshot.docs.forEach((DocumentSnapshot document) {
      CategoryModel categoryModel = CategoryModel.fromSnapshot(document);
      _categories.add(categoryModel);
    });
    loading(false);
  }


  /* CREATE CATEGORY ----------------------------------------------------------------*/

  createCategory(String name, allDefaultFields) async {

    DocumentReference doc = await FirebaseFirestore.instance.collection('aerotec/categories/categories').add({
      'name': name,
      'fields': List.generate(allDefaultFields.length, (index) {
        Field e = allDefaultFields[index];

        return {
          "label": e.label,
          "name": e.name,
          "type": e.type,
          "options": e.options,
          "position": index + 1,
          "main_type": e.mainType
        };
      })
    });

    Fluttertoast.showToast(
      msg: "New Category Added",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0
    );

    return doc;
  }

  /* UPDATE CATEGORY ----------------------------------------------------------------*/

  updateCategory(String id, String name, allFields) async {

    final equipment = {
      'name': name,
      'fields': List.generate(allFields.length, (index) {
        Field e = allFields[index];
        return {
          "label": e.label,
          "name": e.name,
          "type": e.type,
          "options": e.options,
          "position": index + 1,
          "main_type": e.mainType,
          "value": null,
          "is_optional": e.isOptional ?? false,
        };
      })
    };

    await FirebaseFirestore.instance.collection('aerotec/categories/categories').doc(id).set(equipment);

    Fluttertoast.showToast(
      msg: "Category Updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0
    );

    return null;
  }
}
