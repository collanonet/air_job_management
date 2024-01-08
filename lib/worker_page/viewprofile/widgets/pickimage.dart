import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return File(_file.path);
  }
  print('No Image Selected');
}

fileToUrl(Uint8List? file, String folderName) async {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //Create a reference to the location you want to upload to in firebase
  try {
    Reference reference = _storage.ref().child("/$folderName/${DateTime.now()}.jpg");

    //Upload the file to firebase
    TaskSnapshot storageTaskSnapshot = await reference.putData(file!);

    // Waits till the file is uploaded then stores the download url
    var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    //returns the download url
    return dowUrl;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
