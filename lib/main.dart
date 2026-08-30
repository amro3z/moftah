import 'package:flutter/material.dart';
import 'package:moftah/routing/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final AppRoute _appRoute = AppRoute();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appRoute.onGenerateRoute,
      initialRoute: '/technician/register',
    );
  }
}
