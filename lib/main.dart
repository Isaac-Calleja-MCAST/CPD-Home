import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/spot_provider.dart';
import './screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('spotsBox');

  final platformImplementation = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  // This triggers the "Allow Malta Spot Saver to send notifications?" popup
  if (platformImplementation != null) {
    await platformImplementation.requestNotificationsPermission();
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    // wrapped the app in the Provider so every screen can access the data
    ChangeNotifierProvider(
      create: (ctx) => SpotProvider()..loadSpots(),
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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: const HomeScreen(),
    );
  }
}
