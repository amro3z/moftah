import 'package:flutter/material.dart';
import 'package:moftah/data/models/app_user_role_enum.dart';

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
