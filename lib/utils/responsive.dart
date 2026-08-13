import 'package:flutter/material.dart';

class ResponsiveSize {
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 600;
  }

  static double width(BuildContext context, double percentage) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return screenWidth * (percentage / 100);
  }

  static double height(BuildContext context, double percentage) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return screenHeight * (percentage / 100);
  }
}
