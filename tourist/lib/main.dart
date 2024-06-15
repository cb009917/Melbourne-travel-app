import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist/activities%20page/Balloon_ride.dart';
import 'package:tourist/activities%20page/river_cruise.dart';
import 'package:tourist/activities%20page/wine_testing.dart';
import 'package:tourist/auth_user.dart';
import 'package:tourist/components.dart';
import 'package:tourist/dark_mode.dart';
import 'package:tourist/forgot.dart';
import 'package:tourist/home.dart';
import 'package:tourist/homepage.dart';
import 'package:tourist/login.dart';
import 'package:tourist/battery_level.dart';
import 'package:tourist/provider/provider.dart';
import 'package:tourist/register.dart';
import 'package:tourist/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BatteryManager()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      // home: HomePage(),
      initialRoute: 'index',
      routes: {
        'login': (context) => LogIn(),
        'register': (context) => Register(),
        'homepage': (context) => home_page(),
        'index': (context) => HomePage(),
        'rivercruise': (context) => RiverCruise(),
        'winetesting': (context) => WineTesting(),
        'ballonride': (context) => Ballon(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
