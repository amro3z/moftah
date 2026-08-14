import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/data/models/home_options_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/widgets/custom_appbar.dart';
import 'package:moftah/ui/home/widgets/home_options_list.dart';
import 'package:moftah/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            customAppBar(
              context,
              userName: 'عمرو محمد',
              data: VehicleCardModel(
                carName: 'Toyota Corolla',
                year: 2020,
                mileage: 100008,
                healthScore: 85,
                maintenanceStatus: MaintenanceStatus.good,
                documentStatus: DocumentStatus.verified,
                imageUrl:
                    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
                nextMaintenance: 1500,
                lastMaintenance: '15 مارس',
                repairStatus: RepairStatus.good,
              ),
              onChatTap: () {},
              onVehicleTap: () {},
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.5)),
            HomeOptionsList(
              options: HomeOptionsInfo.options,
            ),
          ],
        ),
      ),
    );
  }
}

