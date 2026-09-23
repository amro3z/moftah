import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';

class TechnicianScaffold extends StatelessWidget {
  final Widget body;
  final int? current;
  final String? title;
  final bool withBackArrow;
  const TechnicianScaffold({
    super.key,
    required this.body,
    this.current,
    this.title,
    this.withBackArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (current == 0) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.background,
          body: body,
          bottomNavigationBar: current == null
              ? null
              : TechnicianBottomNav(current: current!),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: withBackArrow
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          customText(
                            text: title ?? '',
                            fontSize: 20,
                            isBold: true,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                        ],
                      )
                    : Center(
                        child: customText(
                          text: title ?? '',
                          fontSize: 20,
                          isBold: true,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, 5),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: body,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: current == null
            ? null
            : TechnicianBottomNav(current: current!),
      ),
    );
  }
}
