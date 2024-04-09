import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist/activities%20page/Balloon_ride.dart';
import 'package:tourist/dark_mode.dart';
import 'package:tourist/forgot.dart';
import 'package:tourist/home.dart';
import 'package:tourist/homepage.dart';
import 'package:tourist/login.dart';
import 'package:tourist/provider/provider.dart';
import 'package:tourist/register.dart';
import 'package:tourist/settings.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
