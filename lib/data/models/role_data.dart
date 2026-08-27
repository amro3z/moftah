import 'package:flutter/material.dart';
import 'package:moftah/ui/onboarding/role_selection_screen.dart';

class RoleData {
  final AppUserRole role;
  final String title;
  final String subtitle;
  final IconData icon;

  const RoleData({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
