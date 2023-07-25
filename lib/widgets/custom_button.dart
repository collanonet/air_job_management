import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;
  const ButtonWidget(
      {required this.title, required this.color, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), color: color),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () => onPress(),
      ),
    );
  }
}
