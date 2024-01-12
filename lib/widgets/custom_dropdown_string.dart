import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatelessWidget {
  final List<String> list;
  final String? selectItem;
  final Function onChange;
  final double? width;
  final double? radius;
  const CustomDropDownWidget({Key? key, required this.list, required this.onChange, this.selectItem, this.width = 200, this.radius = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: InputDecorator(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius!)),
            )),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: selectItem, items: list.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (e) => onChange(e)),
        ),
      ),
    );
  }
}
