import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/themes/colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String? message;

  const AppLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 5.64),
          vertical: ResponsiveSize.height(context, 1.9),
        ),
        decoration: _panelDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: ResponsiveSize.width(context, 8.72),
              height: ResponsiveSize.height(context, 4.03),
              child: CircularProgressIndicator(
                strokeWidth: ResponsiveSize.width(context, 0.77),
                strokeCap: StrokeCap.round,
                color: AppColors.secondary,
                backgroundColor: Color(0xFFE6EEF8),
              ),
            ),
            if (message != null) ...[
              SizedBox(height: ResponsiveSize.height(context, 1.42)),
              Text(message!, textAlign: TextAlign.center, style: _messageStyle),
            ],
          ],
        ),
      ),
    );
  }
}

class AppRetryIndicator extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppRetryIndicator({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 5.64),
          vertical: ResponsiveSize.height(context, 1.9),
        ),
        decoration: _panelDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveSize.width(context, 9.74),
              height: ResponsiveSize.height(context, 4.5),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: AppColors.secondary,
                size: ResponsiveSize.width(context, 5.64),
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.18)),
            Text(message, textAlign: TextAlign.center, style: _messageStyle),
            SizedBox(height: ResponsiveSize.height(context, 1.18)),
            InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 4.62),
                  vertical: ResponsiveSize.height(context, 0.95),
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  'حاول مرة أخرى',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final BoxDecoration _panelDecoration = BoxDecoration(
  color: Colors.white.withValues(alpha: 0.96),
  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.10),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);

final TextStyle _messageStyle = TextStyle(
  fontFamily: 'Cairo',
  fontSize: AppSizes.fontMd,
  fontWeight: FontWeight.w600,
  color: AppColors.primary,
);
