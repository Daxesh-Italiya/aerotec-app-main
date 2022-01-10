import 'dart:io';
import 'package:aerotec_flutter_app/services/image_service.dart';
import 'package:aerotec_flutter_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  String? _userEmail;
  UserModel? get user => _user;
  get userEmail => _userEmail;

  subUser(String email) async {
    Stream documentStream = FirebaseFirestore.instance.collection('aerotec/users/users').doc(email).snapshots();
    documentStream.listen((snapshot) {
      UserModel user = UserModel.fromSnapshot(snapshot);
      _user = user;
      _userEmail = user.id;
      notifyListeners();
    });
  }

  Future uploadProfileImage(File image) async {
    var url = await ImageService.upload(image, 'users/$userEmail', userEmail + '.jpg');
    DocumentReference userRef = FirebaseFirestore.instance.collection('aerotec/users/users').doc('$userEmail');
    return userRef.update({
      'imageUrl': url
    });
  }

}
