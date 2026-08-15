import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/ui/core/constant/home_options.dart';
import 'package:moftah/ui/core/constant/nerbay_places.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/section_title.dart';
import 'package:moftah/ui/home/widgets/current%20repair/current_repair_card.dart';
import 'package:moftah/ui/home/widgets/custom_appbar.dart';
import 'package:moftah/ui/home/widgets/home%20options/home_options_list.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nerbay_places.dart';
import 'package:moftah/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
              HomeOptionsList(options: HomeOptionsInfo.options),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              const SectionTitle(title: 'الإصلاح الحالي'),
              SizedBox(height: ResponsiveSize.height(context, 1)),

              CurrentRepairCard(
                data: const CurrentRepairModel(
                  title: 'تغيير زيت المحرك + فلتر',
                  workshopName: 'Auto Pro Center',
                  location: 'مدينة نصر',
                  currentStage: RepairStage.repairing,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/repair-details');
                },
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              const SectionTitle(
                title: 'ورش قريبة منك',
                actionText: 'عرض الخريطة',
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              HomeNearbyPlacesList(
                nearbyPlaces: HomeNearbyPlacesInfo.places,
              ),
              SizedBox(height: ResponsiveSize.height(context, 10.5)),
            ],
          ),
        ),
      ),
    );
  }
}



