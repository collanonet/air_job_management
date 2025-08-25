import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    if (newText.length > oldText.length) {
      if (newText.length == 5 && !newText.endsWith('/')) {
        return newValue.copyWith(
          text: '${oldText.substring(0, 4)}/${newText.substring(4)}',
          selection: TextSelection.collapsed(offset: newText.length + 1),
        );
      }
      if (newText.length == 8 && !newText.endsWith('/')) {
        return newValue.copyWith(
          text: '${oldText.substring(0, 7)}/${newText.substring(7)}',
          selection: TextSelection.collapsed(offset: newText.length + 1),
        );
      }
    }
    return newValue;
  }
}