import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_state.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_part_image.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_parts_app_bar.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_parts_checkout_dialog.dart';
import 'package:moftah/data/store/profile_history_store.dart';

class SparePartsCartScreen extends StatelessWidget {
  const SparePartsCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const SparePartsAppBar(
          title: 'سلة المشتريات',
          showBack: true,
          showActions: false,
        ),
        body: BlocBuilder<SparePartsCubit, SparePartsState>(
          builder: (context, state) {
            final products = state.cartProducts;
            if (products.isEmpty) return const _EmptyCart();

            final delivery = state.cartSubtotal >= 1500 ? 0.0 : 60.0;
            final total = state.cartSubtotal + delivery;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(ResponsiveSize.width(context, 3.08), ResponsiveSize.height(context, 1.66), ResponsiveSize.width(context, 3.08), ResponsiveSize.height(context, 1.42)),
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final part = products[index];
                      final quantity = state.cartQuantities[part.id] ?? 1;
                      return _CartItem(
                        partName: part.name,
                        brand: part.brand,
                        imageUrl: part.imageUrl,
                        price: part.price,
                        quantity: quantity,
                        onIncrease: () => context.read<SparePartsCubit>().addToCart(part.id),
                        onDecrease: () => context.read<SparePartsCubit>().decreaseCart(part.id),
                        onDelete: () => context.read<SparePartsCubit>().removeFromCart(part.id),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(ResponsiveSize.width(context, 3.59), ResponsiveSize.height(context, 1.54), ResponsiveSize.width(context, 3.59), ResponsiveSize.height(context, 1.66)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: .08),
                        blurRadius: 18,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        if (delivery > 0) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2.82), vertical: ResponsiveSize.height(context, 1.07)),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_shipping_outlined,
                                  color: AppColors.secondary,
                                  size: ResponsiveSize.width(context, 4.87),
                                ),
                                SizedBox(width: ResponsiveSize.width(context, 2.05)),
                                Expanded(
                                  child: customText(
                                    text:
                                        'أضف ${(1500 - state.cartSubtotal).clamp(0, 1500).toStringAsFixed(0)} جنيه للحصول على توصيل مجاني',
                                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                                    isBold: true,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 1.3)),
                        ],
                        _SummaryRow(
                          label: 'الإجمالي الفرعي',
                          value: '${state.cartSubtotal.toStringAsFixed(0)} جنيه',
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 0.71)),
                        _SummaryRow(
                          label: 'التوصيل',
                          value: delivery == 0 ? 'مجاني' : '${delivery.toStringAsFixed(0)} جنيه',
                          valueColor: delivery == 0 ? AppColors.success : null,
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 1.18)),
                        Divider(height: ResponsiveSize.height(context, 0.12), color: AppColors.border.withValues(alpha: .12)),
                        SizedBox(height: ResponsiveSize.height(context, 1.18)),
                        _SummaryRow(
                          label: 'الإجمالي',
                          value: '${total.toStringAsFixed(0)} جنيه',
                          bold: true,
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 1.54)),
                        FilledButton.icon(
                          onPressed: () => _checkout(context, total),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            minimumSize: const Size.fromHeight(51),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            ),
                          ),
                          icon: Icon(Icons.lock_outline_rounded, size: ResponsiveSize.width(context, 4.62)),
                          label: customText(
                            text: 'إتمام الطلب',
                            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                            isBold: true,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _checkout(BuildContext context, double total) async {
    final confirmed = await showSparePartsCheckoutDialog(
      context: context,
      total: total,
    );

    if (confirmed != true || !context.mounted) return;

    final cubit = context.read<SparePartsCubit>();
    final products = cubit.state.cartProducts;
    final quantities = Map<String, int>.from(
      cubit.state.cartQuantities,
    );

    ProfileHistoryStore.instance.addSparePartOrder(
      products: products,
      quantities: quantities,
      total: total,
    );

    cubit.clearCart();

    if (!context.mounted) return;
    await showSparePartsOrderSuccessDialog(context);
  }
}

class _CartItem extends StatelessWidget {
  final String partName;
  final String brand;
  final String imageUrl;
  final double price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const _CartItem({
    required this.partName,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1.18)),
      padding: EdgeInsets.all(ResponsiveSize.width(context, 2.82)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: .10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SparePartImage(imageUrl: imageUrl, size: ResponsiveSize.width(context, 17.95)),
          SizedBox(width: ResponsiveSize.width(context, 2.56)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: partName,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  isBold: true,
                  color: AppColors.primary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveSize.height(context, 0.24)),
                customText(
                  text: brand,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.textMuted,
                ),
                SizedBox(height: ResponsiveSize.height(context, 0.95)),
                Row(
                  children: [
                    customText(
                      text: '${(price * quantity).toStringAsFixed(0)} جنيه',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      isBold: true,
                      color: AppColors.primary,
                    ),
                    const Spacer(),
                    _QuantityButton(icon: Icons.remove_rounded, onTap: onDecrease),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2.56)),
                      child: customText(
                        text: '$quantity',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                        isBold: true,
                        color: AppColors.primary,
                      ),
                    ),
                    _QuantityButton(icon: Icons.add_rounded, onTap: onIncrease),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2.05)),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: ResponsiveSize.width(context, 5.13)),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.danger.withValues(alpha: .08),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusXs),
      child: Container(
        width: ResponsiveSize.width(context, 7.44),
        height: ResponsiveSize.height(context, 3.44),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
        ),
        child: Icon(icon, color: AppColors.secondary, size: ResponsiveSize.width(context, 4.36)),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        customText(
          text: label,
          fontSize: bold ? 12 : 10,
          isBold: bold,
          color: bold ? AppColors.primary : AppColors.textMuted,
        ),
        const Spacer(),
        customText(
          text: value,
          fontSize: bold ? 14 : 10,
          isBold: true,
          color: valueColor ?? AppColors.primary,
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveSize.width(context, 7.18)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveSize.width(context, 21.54),
              height: ResponsiveSize.height(context, 9.95),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: ResponsiveSize.width(context, 10.26),
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.78)),
            customText(
              text: 'السلة فاضية',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
              isBold: true,
              color: AppColors.primary,
            ),
            SizedBox(height: ResponsiveSize.height(context, 0.59)),
            customText(
              text: 'ضيف قطع الغيار اللي محتاجها وهتظهر هنا',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveSize.height(context, 2.01)),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
              icon: Icon(Icons.storefront_rounded),
              label: customText(
                text: 'تصفح قطع الغيار',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                isBold: true,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
