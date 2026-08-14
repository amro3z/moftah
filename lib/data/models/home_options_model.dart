import 'package:flutter/material.dart';

class HomeOptionItemModel {
  final IconData icon;
  final String title;
  final String path;

  const HomeOptionItemModel({
    required this.icon,
    required this.title,
    required this.path,
  });
}

class HomeOptionsInfo {
  HomeOptionsInfo._();

  static const List<HomeOptionItemModel> options = [
    HomeOptionItemModel(
      icon: Icons.build_rounded,
      title: 'بلغ عن عطل',
      path: '/report-problem',
    ),
    HomeOptionItemModel(
      icon: Icons.car_repair_rounded,
      title: 'ورشة قريبة',
      path: '/nearby-workshops',
    ),
    HomeOptionItemModel(
      icon: Icons.engineering_rounded,
      title: 'احجز فني',
      path: '/book-technician',
    ),
    HomeOptionItemModel(
      icon: Icons.settings_suggest_rounded,
      title: 'قطع غيار',
      path: '/spare-parts',
    ),
    HomeOptionItemModel(
      icon: Icons.emergency_rounded,
      title: 'طوارئ',
      path: '/emergency',
    ),
  ];
}
