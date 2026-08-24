import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';

Widget customText({
  required String text,
  required double fontSize,
  bool? isBold,
  Color? color,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
      fontSize: fontSize,
      fontFamily: 'Cairo',
      color: color ?? AppColors.textPrimary,
    ),
  );
}
