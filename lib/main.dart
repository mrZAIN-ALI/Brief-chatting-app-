import 'package:chit_chat/firebase_options.dart';
import 'package:chit_chat/screens/splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//
import './screens/home_screen.dart';
import './screens/auth_Screens/login_Screen.dart';

//
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chit Chat',
      theme: ThemeData(
        //
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        //
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
              fontWeight: FontWeight.bold),
          bodySmall: TextStyle(
              fontFamily: "Lato",
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
