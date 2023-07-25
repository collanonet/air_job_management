import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final String hintText;
  final bool isSecureText;
  final int maxLine;
  final Color? bgColor;
  final bool? isFromLogin;
  CustomTextFieldWidget(
      {required this.controller,
      this.isFromLogin,
      required this.isSecureText,
      required this.width,
      required this.hintText,
      required this.maxLine,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: maxLine == 1
            ? 50
            : maxLine == 4
                ? 30
                : maxLine == 3
                    ? 150
                    : 200,
        padding: EdgeInsets.only(left: maxLine == 4 ? 5 : 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: bgColor != null ? Colors.white : Color(0xffF0F0F0),
            border: Border.all(width: 0.6, color: Colors.grey)),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          obscureText: isSecureText,
          maxLines: maxLine == 4 ? 1 : maxLine,
          inputFormatters: isFromLogin != null && isFromLogin == true
              ? null
              : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration.collapsed(hintText: hintText),
        ),
      ),
    );
  }
}
