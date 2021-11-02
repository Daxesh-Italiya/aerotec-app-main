import 'package:aerotec_flutter_app/models/components_model.dart';
import 'package:aerotec_flutter_app/services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

class ComponentsProvider extends ChangeNotifier {
  List<ComponentsModel> _componentsProvider = [];
  bool _isLoading = false;
  StreamSubscription? subscription;

  bool get isLoading => _isLoading;
  get componentsProvider => _componentsProvider;

  loading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  subData() {
    subscription?.cancel();
    subscription = FirebaseFirestore.instance.collection('components').snapshots().listen(getData);
  }

  getData(snapshot) {
    loading(true);
    _componentsProvider.clear();
    snapshot.docs.forEach((DocumentSnapshot document) {
      ComponentsModel component = ComponentsModel.fromSnapshot(document);
      _componentsProvider.add(component);
    });
    loading(false);
  }

  /* UPDATE LISTING ----------------------------------------------------------------*/

  updateComponent(ComponentsModel component,  File? image) async {
    CollectionReference componentsRef = FirebaseFirestore.instance.collection('components');
    String fileUrl = '';

    loading(true);
    if(image != null) {
      fileUrl = await ImageService.upload(image, 'components');
    }

    return componentsRef.doc(component.id).update({
      'name': component.name,
      'category': component.category,
      'description': component.description,
      'partNumber': component.partNumber,
      'safeWorkingLoad': component.safeWorkingLoad,
      'serialNumber': component.serialNumber,
      'timeBetweenOverhauls': component.timeBetweenOverhauls,
      'imagePath': fileUrl,
      'inspectionDate': component.inspectionDate,
      'nextInspectionDate': component.nextInspectionDate,
      'datePurchased': component.datePurchased,
      'datePutIntoService': component.datePutIntoService,
    
    }).then((value) { 
      loading(false);
    });
  }

  /* CREATE LISTING ----------------------------------------------------------------*/

  createNewComponent(ComponentsModel component, File image) async {
    CollectionReference components = FirebaseFirestore.instance.collection('components');

    loading(true);

    String fileUrl = await ImageService.upload(image, 'components');

    return components.add({
      'name': component.name,
      'category': component.category,
      'description': component.description,
      'partNumber': component.partNumber,
      'safeWorkingLoad': component.safeWorkingLoad,
      'serialNumber': component.serialNumber,
      'timeBetweenOverhauls': component.timeBetweenOverhauls,
      'imagePath': fileUrl,
      'inspectionDate': component.inspectionDate,
      'nextInspectionDate': component.nextInspectionDate,
      'datePurchased': component.datePurchased,
      'datePutIntoService': component.datePutIntoService,
    }).then((value) {
      loading(false);
    });
  }
}
