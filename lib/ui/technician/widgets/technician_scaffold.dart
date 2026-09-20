import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';

class TechnicianScaffold extends StatelessWidget {
  final Widget body;
  final int current;
  final String? title;
  const TechnicianScaffold({
    super.key,
    required this.body,
    required this.current,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      appBar: title != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0,
              elevation: 0,
              title: customText(
                text: title ?? '',
                fontSize: 20,
                isBold: true,
                color: AppColors.primary,
              ),
              automaticallyImplyLeading: false,
            )
          : null,
      backgroundColor: AppColors.background,

      body: body,

      bottomNavigationBar: TechnicianBottomNav(current: current),
    );
  }
}
