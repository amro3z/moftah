import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';

class TechnicianScaffold extends StatelessWidget {
  final Widget body;
  final int current;

  const TechnicianScaffold({
    super.key,
    required this.body,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,

      body: body,

      bottomNavigationBar: TechnicianBottomNav(current: current),
    );
  }
}
