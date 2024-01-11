import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData{

  Future<String> uploadImageToStorage(String childName,Uint8List file)async{
    final FirebaseStorage _storage = FirebaseStorage.instance;

     Reference ref = _storage.ref().child(childName);
     UploadTask uploadTask = ref.putData(file);
       TaskSnapshot snapshot = await uploadTask;
       String downlodaUrl = await snapshot.ref.getDownloadURL();
       return downlodaUrl;

  }
  Future<String?> uploadImageToFirebase(File image) async {
    //Get the file from the image picker and store it
    final FirebaseStorage _storage = FirebaseStorage.instance;
    //Create a reference to the location you want to upload to in firebase
    try {
      Reference reference = _storage.ref().child("/images/${image.path.split("/").last}");

      //Upload the file to firebase
      TaskSnapshot storageTaskSnapshot = await reference.putFile(image);

      // Waits till the file is uploaded then stores the download url
      var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

      //returns the download url
      return dowUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<String> saveData({
    required String name,
     required String gender,
      required Uint8List file,
      }) async{
      String resp = "Some Error Dccured";
      try{
        if(name.isNotEmpty || gender.isNotEmpty)
        {
        String imageUrl = await uploadImageToStorage('profileImage',file);
        await _firestore.collection('user').add({
          'name':name,
          'gender':gender,
          'imageLink': imageUrl,
        });
        resp = 'success';
      }
      }
      catch(err){
        resp = err.toString();
      }
      
      return resp;
  }
}
