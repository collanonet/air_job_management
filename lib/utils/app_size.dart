import 'package:flutter/cupertino.dart';

class AppSize {
  static getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static SizedBox spaceWidth8 = const SizedBox(
    width: 8,
  );
  static SizedBox spaceHeight8 = const SizedBox(
    height: 8,
  );
  static SizedBox spaceHeight5 = const SizedBox(
    height: 5,
  );
  static SizedBox spaceWidth5 = const SizedBox(
    width: 5,
  );
  static SizedBox spaceWidth16 = const SizedBox(
    width: 16,
  );
  static SizedBox spaceWidth32 = const SizedBox(
    width: 32,
  );
  static SizedBox spaceHeight16 = const SizedBox(
    height: 16,
  );
  static SizedBox spaceHeight30 = const SizedBox(
    height: 32,
  );
  static SizedBox spaceHeight50 = const SizedBox(
    height: 50,
  );
}
