import 'dart:async';
import 'dart:io';

import 'package:aerotec_flutter_app/services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import '../models/longlines/longlines_model.dart';

class LongLinesProvider extends ChangeNotifier {
  List<LongLinesModel> _longLinesProvider = [];
  late LongLinesModel _singleListing;
  bool _isLoading = false;
  StreamSubscription? subscription;

  bool get isLoading => _isLoading;
  List<LongLinesModel> get longLinesProvider => _longLinesProvider;
  LongLinesModel get singleListing => _singleListing;

  void loading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  subData() {
    subscription?.cancel();
    subscription = FirebaseFirestore.instance.collection('longlines').snapshots().listen(getData);
  }

  getData(snapshot) {
    _longLinesProvider.clear();
    snapshot.docs.forEach((DocumentSnapshot document) {
      LongLinesModel longLinesModel = LongLinesModel.fromSnapshot(document);
      _longLinesProvider.add(longLinesModel);
    });
    loading(false);
  }

  getSingleListing(String id) {
    loading(true);
    _singleListing = longLinesProvider.singleWhere((element) => element.id == id);
    loading(false);
  }

  /* UPDATE LISTING ----------------------------------------------------------------*/

  updateListing(LongLinesModel longline, File? image) async {
    CollectionReference longlinesRef = FirebaseFirestore.instance.collection('longlines');

    loading(true);
    String fileUrl = image != null ? await ImageService.upload(image, 'longlines') : '';
    return longlinesRef.doc(longline.id).update({
      'name': longline.name,
      'length': longline.length,
      'type': longline.type,
      'imagePath': image == null ? longline.imagePath : fileUrl,
      'safeWorkingLoad': longline.safeWorkingLoad,
      'partNumber': longline.partNumber,
      'serialNumber': longline.serialNumber,
      'timeBetweenOverhauls': longline.timeBetweenOverhauls,
      'inspectionDate': longline.inspectionDate,
      'nextInspectionDate': longline.nextInspectionDate,
      'datePurchased': longline.datePurchased,
      'datePutIntoService': longline.datePutIntoService,
    }).then((value) {
      loading(false);
    });
  }

  /* CREATE LISTING ----------------------------------------------------------------*/

  Future createNewListing(LongLinesModel longline, File? image) async {
    CollectionReference longlinesRef = FirebaseFirestore.instance.collection('longlines');

    loading(true); 
    String fileUrl = image != null ? await ImageService.upload(image, 'longlines') : '';
    return longlinesRef.add({
      'name': longline.name,
      'length': longline.length,
      'type': longline.type,
      'safeWorkingLoad': longline.safeWorkingLoad,
      'partNumber': longline.partNumber,
      'serialNumber': longline.serialNumber,
      'timeBetweenOverhauls': longline.timeBetweenOverhauls,
      'imagePath': fileUrl,
      'inspectionDate': longline.inspectionDate,
      'nextInspectionDate': longline.nextInspectionDate,
      'datePurchased': longline.datePurchased,
      'datePutIntoService': longline.datePutIntoService,
    }).then((value) {
      loading(false);
    });
  }
}
