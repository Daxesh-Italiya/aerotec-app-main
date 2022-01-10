import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  static Future upload(File image, String path, String filename) async {
    // List<String> hashFileName = image.path.split("/");
    // String filename = hashFileName[hashFileName.length - 1];
    File file = File(image.absolute.path);
    try {
      Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child('$path').child('$filename');
      await storageRef.putFile(file);
      return filename;
    } on FirebaseException catch (e) {
      print('Error!');
      print(e.message);
    }
  }
}