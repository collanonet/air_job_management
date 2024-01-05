import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../utils/app_color.dart';

/// {@category Widget}
/// A widget that display the text field with various type of customization, and it is common used in entire app
class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final void Function(String?)? onSubmit;
  final bool isObsecure;
  final bool isPhoneNumber;
  final bool isEmail;
  final Widget? prefix;
  final Widget? suffix;
  final bool isRequired;
  final double marginBottom;
  final TextInputType textInputType;
  final double borderWidth;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final bool readOnly;
  final AutovalidateMode? autoValidateMode;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final int? maxLine;
  final List<TextInputFormatter>? inputFormat;

  const PrimaryTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.inputFormat,
    this.validator,
    this.isEmail = false,
    this.maxLine = 1,
    this.isObsecure = false,
    this.prefix,
    this.suffix,
    this.marginBottom = 12,
    this.textInputType = TextInputType.text,
    this.borderWidth = 0.8,
    this.isRequired = true,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.readOnly = false,
    this.onChange,
    this.onSubmit,
    this.isPhoneNumber = false,
    this.autoValidateMode,
    this.style,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: TextFormField(
        controller: controller,
        onChanged: onChange,
        onTap: onTap ?? null,
        readOnly: readOnly,
        obscureText: isObsecure,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        validator: validator != null
            ? (value) => validator!(value)
            : isEmail && isRequired
                ? (value) => FormValidator.validateEmail(value)
                : isRequired
                    ? (value) {
                        if (validator != null) return validator!(value);
                        return FormValidator.validateField(value, hint);
                      }
                    : null,
        maxLines: maxLine,
        autocorrect: false,
        autovalidateMode: autoValidateMode,
        textCapitalization: textCapitalization,
        onFieldSubmitted: onSubmit,
        style: style,
        inputFormatters: inputFormat != null
            ? [...inputFormat!]
            : isPhoneNumber
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : [],
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefix,
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
          suffixIcon: readOnly
              ? SizedBox()
              : suffix == null
                  ? Icon(
                      FlutterIcons.asterisk_fou,
                      color: readOnly
                          ? AppColor.primaryColor
                          : isRequired
                              ? Colors.red
                              : Colors.transparent,
                      size: 8,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        suffix!,
                        const SpaceX(),
                        Icon(
                          FlutterIcons.asterisk_fou,
                          color: readOnly
                              ? AppColor.primaryColor
                              : isRequired
                                  ? Colors.red
                                  : Colors.transparent,
                          size: 8,
                        ),
                        const SpaceX(16),
                      ],
                    ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: AppColor.thirdColor,
              width: borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                BorderSide(color: AppColor.primaryColor, width: borderWidth),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.red, width: borderWidth),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.red, width: borderWidth),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}

class FormValidator {
  static String? validateField(String? value, String field, {int? length}) {
    if (value == null || value.isEmpty) return "この項目は必須です";
    if (length != null) {
      if (value.length < length) return "この項目は必須です";
    }
    return null;
  }

  static String? validateLatLang(String? value) {
    if (value == null || value.isEmpty) return "この項目は必須です";
    if (!value.contains(", ")) {
      return "緯度と経度が無効です";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "無効な電子メール";
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return emailValid ? null : "無効な電子メール";
  }
}
