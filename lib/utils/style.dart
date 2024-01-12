import 'package:flutter/material.dart';

BoxDecoration boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
);

BoxDecoration boxDecorationNoTopRadius = const BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
);

TextStyle titleStyle = const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Bold");
TextStyle subTitle = const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Regular");
TextStyle normalTextStyle = const TextStyle(fontSize: 14, color: Colors.black, fontFamily: "Regular");

TextStyle kTitleText = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Bold");
TextStyle kNormalText = const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: "Regular");
TextStyle kSubtitleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: "Regular");
