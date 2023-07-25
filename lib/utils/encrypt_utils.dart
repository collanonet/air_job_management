import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class EncryptUtils {
  static final key = Key.fromUtf8('gpsworkkeygpsworkkeygpsworkkey22'); // 32 length keys
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encryptPassword(String pass) {
    final encrypted = encrypter.encrypt(pass, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv); // encrypted as base64
    return encrypted.base64;
  }

  static String decryptedPassword(String pass) {
    Encrypted encrypted = Encrypted(base64Decode(pass));
    final decrypted = encrypter.decrypt(encrypted, iv: iv); // encrypted as base64
    return decrypted;
  }
}
