import 'package:flutter/material.dart';
import 'package:moftah/data/models/car_owner/profile_history_models.dart';
import 'package:moftah/data/store/profile_history_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class SparePartOrdersScreen extends StatelessWidget {
  const SparePartOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ProfileHistoryStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _historyAppBar(context, 'طلبات قطع الغيار'),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final orders = store.sparePartOrders;

            return ListView.separated(
              padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: ResponsiveSize.height(context, 1)),
              itemBuilder: (context, index) {
                final order = orders[index];

                return _OrderCard(order: order);
              },
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final SparePartOrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: () => Navigator.pushNamed(
          context,
          '/profile/spare-order-details',
          arguments: order,
        ),
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.border.withValues(alpha: .10)),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 12),
                height: ResponsiveSize.width(context, 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  color: AppColors.secondary,
                  size: ResponsiveSize.width(context, 6),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'طلب #${order.id}',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    customText(
                      text:
                          '${order.items.length} منتج • ${order.total.toStringAsFixed(0)} جنيه',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                    customText(
                      text: order.dateLabel,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              _StatusChip(status: order.status),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'تم التوصيل'
        ? AppColors.success
        : AppColors.secondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, .5),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: customText(
        text: status,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        color: color,
        isBold: true,
      ),
    );
  }
}

PreferredSizeWidget _historyAppBar(BuildContext context, String title) {
  return AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
    backgroundColor: AppColors.primary,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: ResponsiveSize.width(context, 5),
          ),
        ),
        Expanded(
          child: customText(
            text: title,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
            color: Colors.white,
            isBold: true,
          ),
        ),
      ],
    ),
  );
}
