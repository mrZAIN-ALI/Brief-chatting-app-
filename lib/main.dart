import 'package:flutter/material.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "TimesNewRoman",

          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF8d67f8),
            onPrimary: Colors.white,
            secondary: Color.fromARGB(255, 177, 159, 227),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.black,
            background: Colors.white,
            onBackground: Colors.red.shade300,
            surface: Colors.white,
            onSurface: Color(0xFFC5DFF8),
          ),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),

          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontFamily: "Lato",
                fontSize: 52.0,
                fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                fontFamily: "Lato",
                fontSize: 36.0,
                fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(
                fontFamily: "Lato",
                fontSize: 25.0,
                fontWeight: FontWeight.normal),
            bodySmall: TextStyle(
                fontFamily: "Lato",
                fontSize: 20.0,
                fontWeight: FontWeight.normal),
          ),
        ),
        home: Placeholder(),
      ),
    );
  }
}
