import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';

Widget customText({required String text , required double fontSize ,  bool? isBold,  Color? color}) {
  return Text(
    text,
    style: TextStyle(
       fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
      fontSize: fontSize,
      fontFamily: 'Cairo',
      color: color ?? AppColors.textColor,
    ),
  );
}
