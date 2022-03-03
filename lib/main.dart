import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'screens/home_page.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        canvasColor: Colors.black,
        textTheme: TextTheme(
            bodyText1: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
            ),
            bodyText2: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
            ),
            headline1: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            headline2: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            headline3: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            headline4: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal)),
      ),
      home: HomePage(),
    );
  }
}
