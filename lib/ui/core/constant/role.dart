import 'package:flutter/material.dart';
import 'package:moftah/data/models/role_data.dart';
import 'package:moftah/ui/onboarding/role_selection_screen.dart';

const roles = [
    RoleData(
      role: AppUserRole.driver,
      title: 'صاحب عربية',
      subtitle: 'صيانة، قطع غيار، ورش ومساعدة على الطريق',
      icon: Icons.directions_car_filled_rounded,
    ),
    RoleData(
      role: AppUserRole.technician,
      title: 'فني',
      subtitle: 'استقبل طلبات الصيانة واعرض خبرتك للعملاء',
      icon: Icons.engineering_rounded,
    ),
    RoleData(
      role: AppUserRole.workshopOwner,
      title: 'صاحب مركز صيانة',
      subtitle: 'أدر مركزك واستقبل طلبات ومواعيد جديدة',
      icon: Icons.storefront_rounded,
    ),
    RoleData(
      role: AppUserRole.towOperator,
      title: 'ونش',
      subtitle: 'استقبل طلبات المساعدة القريبة من نطاقك',
      icon: Icons.local_shipping_rounded,
    ),
  ];