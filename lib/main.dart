import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/spot_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(
    // wrapped the app in the Provider so every screen can access the data
    ChangeNotifierProvider(
      create: (ctx) => SpotProvider(),
      child: const MaltaSpotApp(),
    ),
  );
}

class MaltaSpotApp extends StatelessWidget {
  const MaltaSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malta Spot Saver',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}