import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// /// A form field for entering time in HH:mm format (24h).
class TimePickerField extends StatefulWidget {
  final String? label;
  final String? helperText;
  final TextEditingController? initialTime;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const TimePickerField({
    Key? key,
    this.label,
    this.helperText,
    this.initialTime,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTime?.text);
  }

  void _handleChanged(String value) {
    if (_isValidTime(value)) {
      setState(() => _errorText = null);
      widget.onChanged?.call(value);
    } else {
      setState(() => _errorText = 'Invalid time');
    }
  }

  void _handleSubmitted(String value) {
    if (_isValidTime(value)) {
      setState(() => _errorText = null);
      widget.onSubmitted?.call(value);
    } else {
      setState(() => _errorText = 'Invalid time');
    }
  }

  bool _isValidTime(String value) {
    if (!value.contains(':') || value.length < 5) return false;
    final parts = value.split(':');
    if (parts.length != 2) return false;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return false;
    if (hour < 0 || hour > 23) return false;
    if (minute < 0 || minute > 59) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
          _TimeTextFormatter(),
        ],
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: widget.helperText,
          errorText: _errorText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onChanged: _handleChanged,
        onSubmitted: _handleSubmitted,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Formatter for `HH:mm`
class _TimeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(':', '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    if (digitsOnly.length <= 2) {
      return newValue.copyWith(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
    }

    final hour = digitsOnly.substring(0, 2);
    final minute = digitsOnly.substring(2);
    final newText = '$hour:$minute';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
