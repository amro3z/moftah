import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/ui/home/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
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
      body: const Center(child: Text('Welcome to the Home Screen!')),
    );
  }
}
