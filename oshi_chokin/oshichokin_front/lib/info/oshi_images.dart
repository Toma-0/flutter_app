import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class imageSet {
  Image? _img;
  static List<Widget> images = [];

  Future<List<Widget>> download(uid, oshiName) async {
    final db = FirebaseFirestore.instance;
    final docRef = db
        .collection('users')
        .doc(uid)
        .collection("oshi")
        .doc(oshiName)
        .collection("images");

    final ref = await docRef.get();
    int number = ref.size;

    for (int i = 0; i < number; i++) {
      final result = await docRef.doc((i).toString()).get();
      final document = docRef.doc((i).toString());

      if (result.exists) {
        final data = result.data()!;

        if (result.id != null && result.id.isNotEmpty) {
          String? imageUrl = result.get('imageURL');

          if (imageUrl == null) {
            images.add(IconButton(
                onPressed: () {
                  upload(oshiName, uid);
                },
                icon: Icon(Icons.image)));
          } else {
            images.add(Container(
              child: Image.network(imageUrl, fit: BoxFit.cover),
              height: 100.0,
            ));
          }
        } else {
          // ドキュメントには存在しないフィールドであるため、ログなどに警告を出力する
          images.add(IconButton(
              onPressed: () {
                upload(oshiName, uid);
              },
              icon: Icon(Icons.image)));
          print('The requested field does not exist in the document!');
        }
      } else {
        // ドキュメント自体が存在しないため、エラーをログなどに出力する
        images.add(IconButton(
            onPressed: () {
              upload(oshiName, uid);
            },
            icon: Icon(Icons.image)));
        print('The requested document does not exist!');
      }
    }

    return images;
  }

  void upload(oshiName, uid) async {
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }

    File file = File(pickerFile.path);
    late Future<int> images;

    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      final db = FirebaseFirestore.instance;
      final docNumRef =
          db.collection('users').doc(uid).collection("oshi").doc(oshiName);

      Future<int> imageNum(db, docNumRef, uid, oshiName) async {
        String random_str = DateTime.now().toIso8601String();

        final ref = await docNumRef.get();
        final images = ref.get("imageNum") + 1;
        await docNumRef.update({"imageNum": images});

        return images;
      }

      images = imageNum(db, docNumRef, uid, oshiName);

      var storeImage = storage.ref().child("UL/$oshiName/$images");
      await storeImage.putFile(file);
      String imageUrl = await storeImage.getDownloadURL();

      final docRef = db
          .collection('users')
          .doc(uid)
          .collection("oshi")
          .doc(oshiName)
          .collection("images");
      final ref = await docRef.get();
      int number = ref.docs.length;

      await docRef.doc(number.toString()).set({
        'imageURL': imageUrl,
      });

      await docNumRef.set({
        "imageNum": number,
      });
    } catch (e) {
      print(e);
    }
    download(uid, oshiName);
  }
}
