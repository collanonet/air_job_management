import 'package:air_job_management/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;
  const ButtonWidget(
      {required this.title,
      this.color = const Color(0xfff38301),
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Text(
          title,
          style: normalTextStyle.copyWith(
              color: color == Colors.white ? Colors.black : Colors.white),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}
