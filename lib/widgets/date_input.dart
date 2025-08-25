// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:intl/intl.dart';

/// Date text input with validation (YYYY/MM/DD). No calendar picker.
class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    this.label,
    this.helperText,
    this.firstDate,
    this.initialDate,
    this.lastDate,
    this.initialText,
    this.onChanged,
    this.onSubmitted,
  });

  final String? label;
  final String? helperText;
  final DateTime? firstDate;
  final DateTime? initialDate;
  final DateTime? lastDate;
  final String? initialText;
  final void Function(DateTime?)? onChanged;
  final void Function(DateTime?)? onSubmitted;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final _controller = TextEditingController();
  final _dateFormat = DateFormat('yyyy/MM/dd');
  final _dateRegex =
      RegExp(r'^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])$');

  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _controller.text = widget.initialText!;
    } else if (widget.initialDate != null) {
      _controller.text = _dateFormat.format(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String value) {
    if (value.isEmpty) return '日付を入力してください';
    if (!_dateRegex.hasMatch(value)) return '日付をYYYY/MM/DD形式で入力してください';
    final parsed = _parse(value);
    if (parsed == null) return '無効な日付';

    final first = widget.firstDate ?? DateTime(1900);
    final last = widget.lastDate ?? DateTime(2100);
    if (parsed.isBefore(_stripTime(first)) || parsed.isAfter(_stripTime(last))) {
      return '選択可能範囲外の日付です';
    }
    return null;
  }

  DateTime? _parse(String value) {
    try {
      final parts = value.split('/');
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      final dt = DateTime(y, m, d);
      if (dt.year != y || dt.month != m || dt.day != d) return null; // invalid (e.g., 2025/02/31)
      return dt;
    } catch (_) {
      return null;
    }
  }

  DateTime _stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  void _handleChanged(String value) {
    final err = _validate(value);
    setState(() => _errorText = err);
    widget.onChanged?.call(err == null ? _parse(value) : null);
  }

  void _handleSubmitted(String value) {
    final err = _validate(value);
    setState(() => _errorText = err);
    widget.onSubmitted?.call(err == null ? _parse(value) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.done,
        autocorrect: false,
      
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
          LengthLimitingTextInputFormatter(10),
          _YmdSlashFormatter(), // auto-insert slashes -> YYYY/MM/DD
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.helperText ?? 'YYYY/MM/DD',
          errorText: _errorText,
        ),
        onChanged: _handleChanged,
        onSubmitted: _handleSubmitted,
      ),
    );
  }
}

/// Auto formats to `YYYY/MM/DD` and PRESERVES caret so backspace works.
class _YmdSlashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Respect IME composing (e.g., JP keyboard). Don't interfere mid-composition.
    if (newValue.composing.isValid) return newValue;

    // Remove slashes -> keep only digits
    String newDigits = newValue.text.replaceAll('/', '');
    if (newDigits.length > 8) newDigits = newDigits.substring(0, 8); // YYYYMMDD max

    // Rebuild with slashes YYYY/MM/DD
    String formatted = _applyMask(newDigits);

    // Count how many digits are before the cursor in the *unformatted* input
    final digitsBeforeCursor = _countDigitsBefore(newValue.text, newValue.selection.end)
        .clamp(0, newDigits.length);

    // Map that digit count to a cursor index in the *formatted* string
    final cursor = _offsetForDigitIndex(formatted, digitsBeforeCursor);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }

  String _applyMask(String digits) {
    final b = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      b.write(digits[i]);
      if (i == 3 || i == 5) b.write('/'); // after YYYY and MM
    }
    return b.toString();
  }

  int _countDigitsBefore(String text, int cursorOffset) {
    int count = 0;
    final end = cursorOffset.clamp(0, text.length);
    for (var i = 0; i < end; i++) {
      final ch = text.codeUnitAt(i);
      if (ch >= 0x30 && ch <= 0x39) count++; // '0'..'9'
    }
    return count;
  }

  int _offsetForDigitIndex(String formatted, int digitIndex) {
    if (digitIndex <= 0) return 0;
    int seen = 0;
    for (var i = 0; i < formatted.length; i++) {
      final ch = formatted.codeUnitAt(i);
      if (ch >= 0x30 && ch <= 0x39) {
        seen++;
        if (seen == digitIndex) {
          // Caret should be *after* this digit
          return i + 1;
        }
      }
    }
    // If we didn't hit the index, place at end
    return formatted.length;
  }
}
