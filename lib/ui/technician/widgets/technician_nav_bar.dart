import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianBottomNav extends StatelessWidget {
  final int current;

  const TechnicianBottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    const labels = ['الرئيسية', 'الطلبات', 'الأعمال', 'المحادثات', 'حسابي'];

    const icons = [
      Icons.home_rounded,
      Icons.notifications_rounded,
      Icons.work_rounded,
      Icons.chat_bubble_rounded,
      Icons.person_rounded,
    ];

    const routes = [
      '/technician_home',
      '/technician/requests',
      '/technician/works',
      '/technician/chats',
      '/technician/profile',
    ];

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 4),
        0,
        ResponsiveSize.width(context, 4),
        ResponsiveSize.height(context, 1.2),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .18),
              blurRadius: 32,
              spreadRadius: 1,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 1.5),
                vertical: ResponsiveSize.height(context, .7),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.textSecondary.withValues(alpha: .72),
                    AppColors.textSecondary.withValues(alpha: .48),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                border: Border.all(
                  color: AppColors.textSecondary.withValues(alpha: .92),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: List.generate(labels.length, (index) {
                  final selected = index == current;

                  return Expanded(
                    child: InkWell(
                      onTap: selected
                          ? null
                          : () {
                              if (index == 4) {
                                Navigator.pushNamed(context, routes[index]);
                                return;
                              }

                              Navigator.pushReplacementNamed(
                                context,
                                routes[index],
                              );
                            },
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, .65),
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: .08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: ResponsiveSize.width(context, 8.5),
                              height: ResponsiveSize.width(context, 8.5),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.secondary
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.secondary.withValues(
                                            alpha: .25,
                                          ),
                                          blurRadius: 14,
                                          offset: const Offset(0, 5),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                icons[index],
                                color: selected
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                size: ResponsiveSize.width(context, 4.8),
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveSize.height(context, .2),
                            ),
                            customText(
                              text: labels[index],
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXs,
                              ),
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                              isBold: selected,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
