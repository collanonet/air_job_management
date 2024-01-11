import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';

class AirJobManagementWidget extends StatelessWidget {
  final Function onPress;
  final Company? company;
  const AirJobManagementWidget(
      {Key? key, required this.onPress, required this.company})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPress(),
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo22.png",
                width: 200,
              ),
              AppSize.spaceHeight8,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  company?.companyName ?? "",
                  textAlign: TextAlign.center,
                  style: kNormalText.copyWith(
                      color: Colors.black, fontSize: 14, fontFamily: "Bold"),
                ),
              ),
              AppSize.spaceHeight8,
              const Text(
                "Version: 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
