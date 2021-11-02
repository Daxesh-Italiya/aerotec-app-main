import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String imageUrl;

  UserModel({required this.name, required this.id, required this.imageUrl});

  factory UserModel.fromSnapshot(DocumentSnapshot document) {
    Map data = document.data() as Map;
    return UserModel(
      id: document.id,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }
}
