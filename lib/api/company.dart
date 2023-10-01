import 'dart:html' as f;

import 'package:air_job_management/const/status.dart';
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

  Future<void> uploadImageToFirebase(var provider) async {
    try {
      String url = "";
      var input = f.FileUploadInputElement()..accept = 'image/*';
      FirebaseStorage fs = FirebaseStorage.instance;
      input.click();
      input.onChange.listen((event) async {
        final file = input.files!.first;
        final reader = f.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) async {
          var snapshot = await fs.ref().child(file.name).putBlob(file);
          String downloadUrl = await snapshot.ref.getDownloadURL();
          url = downloadUrl;
          provider.onChangeImageUrl(downloadUrl);
        });
      });
    } catch (e) {
      print("Upload image error => " + e.toString());
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

  Future<bool> updateStatusCompany(Company company) async {
    try {
      await companyRef.doc(company.uid).update({"status": StatusUtils.delete});
      return true;
    } catch (e) {
      print("Error updateStatusCompany =>> ${e.toString()}");
      return false;
    }
  }

  Future<List<Company>> getAllCompany() async {
    try {
      var doc =
          await companyRef.where("status", isEqualTo: StatusUtils.active).get();
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
