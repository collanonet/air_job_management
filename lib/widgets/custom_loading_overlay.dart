import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  // ignore: use_key_in_widget_constructors
  const CustomLoadingOverlay({required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: LoadingWidget(AppColor.primaryColor),
      child: child,
      color: Colors.black,
      opacity: 0.4,
    );
  }
}
