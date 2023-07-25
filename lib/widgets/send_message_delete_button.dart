import 'package:flutter/material.dart';

class SendMessageDeleteButtonWidget extends StatelessWidget {
  final String title;
  final Function onPressed;
  const SendMessageDeleteButtonWidget({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1), color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onPressed(),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
