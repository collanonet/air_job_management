import 'package:flutter/material.dart';

import '../../../providers/auth.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';

class RegisterStepWidget extends StatelessWidget {
  final AuthProvider provider;
  final bool isFullTime;
  const RegisterStepWidget(
      {Key? key, required this.provider, required this.isFullTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = AppSize.getDeviceWidth(context);
    return SizedBox(
      width: width,
      height: 30,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: isFullTime ? 5 : 4,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => provider.onChangeStep(index + 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (provider.step == index + 1)
                              ? AppColor.primaryColor
                              : AppColor.thirdColor),
                    ),
                    index == 4 || (isFullTime == false && index == 3)
                        ? const SizedBox()
                        : Container(
                            width: width * 0.09,
                            height: 5,
                            color: AppColor.thirdColor,
                          )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
