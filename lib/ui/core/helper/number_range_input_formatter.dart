import 'package:flutter/services.dart';

class NumberRangeInputFormatter extends TextInputFormatter {
  final int? max;

  NumberRangeInputFormatter({this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final number = int.tryParse(newValue.text);

    if (number == null) {
      return oldValue;
    }

    if (max != null && number > max!) {
      return oldValue;
    }

    return newValue;
  }
}
