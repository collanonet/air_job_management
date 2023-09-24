import 'dart:io';

import 'package:air_job_management/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../const/const.dart';

class CompanyApiServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final CollectionReference companyRef =
      FirebaseFirestore.instance.collection('company');

  Future<String?> uploadImageToFirebase(File image) async {
    //Get the file from the image picker and store it

    //Create a reference to the location you want to upload to in firebase
    try {
      Reference reference =
          _storage.ref().child("/images/${image.path.split("/").last}");

      //Upload the file to firebase
      TaskSnapshot storageTaskSnapshot = await reference.putFile(image);

      // Waits till the file is uploaded then stores the download url
      var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

      //returns the download url
      return dowUrl;
    } catch (e) {
      print("Upload image error " + e.toString());
      return null;
    }
  }

  Future<String?> createCompany(Company company) async {
    try {
      await companyRef.add(company.toJson());
      return ConstValue.success;
    } catch (e) {
      print("Error createUserAccount =>> ${e.toString()}");
      return "$e";
    }
  }

  Future<String?> updateCompanyInfo(Company company) async {
    try {
      await companyRef.doc(company.uid).update(company.toJson());
      return ConstValue.success;
    } catch (e) {
      print("Error updateCompanyInfo =>> ${e.toString()}");
      return "$e";
    }
  }

  Future<List<Company>> getAllCompany() async {
    try {
      var doc = await companyRef.get();
      if (doc.docs.isNotEmpty) {
        List<Company> list = [];
        for (int i = 0; i < doc.docs.length; i++) {
          Company company =
              Company.fromJson(doc.docs[i].data() as Map<String, dynamic>);
          company.uid = doc.docs[i].id;
          list.add(company);
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print("Error getAllCompany =>> ${e.toString()}");
      return [];
    }
  }

  Future<Company?> getACompany(String uid) async {
    try {
      DocumentSnapshot doc = await companyRef.doc(uid).get();
      if (doc.exists) {
        Company company = Company.fromJson(doc.data() as Map<String, dynamic>);
        company.uid = doc.id;
        return company;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error getACompany =>> ${e.toString()}");
      return null;
    }
  }
}
