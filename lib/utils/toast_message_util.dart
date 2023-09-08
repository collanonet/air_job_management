import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

/// {@category Util}
/// A util class of toast that used to return value when on success and error action
void toastMessageSuccess(String msg, BuildContext context, {double? offset, Color? color}) {
  showToast(
    msg,
    context: context,
    axis: Axis.horizontal,
    textStyle: normalTextStyle.copyWith(color: Colors.white),
    textPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    borderRadius: BorderRadius.circular(20.0),
    alignment: Alignment.center,
    backgroundColor: color ?? AppColor.success,
    animation: StyledToastAnimation.slideFromBottomFade,
    reverseAnimation: StyledToastAnimation.slideToBottomFade,
    startOffset: const Offset(0.0, 3.0),
    reverseEndOffset: const Offset(0.0, 3.0),
    position: StyledToastPosition(align: Alignment.bottomCenter, offset: offset ?? 30.0),
    duration: const Duration(seconds: 4),
    animDuration: const Duration(milliseconds: 400),
    curve: Curves.linearToEaseOut,
    reverseCurve: Curves.fastOutSlowIn,
  );
}

void toastMessageError(String msg, BuildContext context, {double? offset}) {
  showToast(
    msg,
    context: context,
    axis: Axis.horizontal,
    textStyle: normalTextStyle.copyWith(color: Colors.white),
    textPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    borderRadius: BorderRadius.circular(20.0),
    alignment: Alignment.center,
    backgroundColor: Colors.red.shade300,
    animation: StyledToastAnimation.slideFromBottomFade,
    reverseAnimation: StyledToastAnimation.slideToBottomFade,
    startOffset: const Offset(0.0, 3.0),
    reverseEndOffset: const Offset(0.0, 3.0),
    position: StyledToastPosition(align: Alignment.bottomCenter, offset: offset ?? 30.0),
    duration: const Duration(seconds: 6),
    animDuration: const Duration(milliseconds: 400),
    curve: Curves.linearToEaseOut,
    reverseCurve: Curves.fastOutSlowIn,
  );
}
