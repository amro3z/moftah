import 'package:flutter/material.dart';
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
        carName: 'Hyundai Elantra',
        year: 2018,
        mileage: '124,500 كم',
        healthScore: 87,
        maintenanceStatus: 'ممتازة',
        documentStatus: 'موثقة',
        imageUrl:
            'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
        nextMaintenance: 'بعد 1,200 كم',
        lastMaintenance: '15 مارس',
        repairStatus: 'جيدة',
        onChatTap: () {},
        onVehicleTap: () {},
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}

