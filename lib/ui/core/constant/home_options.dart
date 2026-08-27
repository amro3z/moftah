import 'package:flutter/material.dart';
import 'package:moftah/data/models/car_owner/home_options_model.dart';

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
      icon: Icons.local_offer_rounded,
      title: 'العروض الواردة',
      path: '/received-offers',
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
