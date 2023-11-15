import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/screens/auth_Screens/login_Screen.dart';
import 'package:chit_chat/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _isAnim_Done = false;
  //
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      Duration(milliseconds: 1500),
      () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.white
          ),
        );
        if (FirebaseAuth.instance.currentUser != null) {
          print(
              "intitstate of splash screen user is : ${Apis.current_User}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => homeScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _media_Q = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        AnimatedPositioned(
          duration: Duration(seconds: 1),
          left: _media_Q.width * .25,
          top: _media_Q.height * .15,
          width: _media_Q.width * .5,
          child: Image.asset(
            "assets/images/icon/icon.png",
          ),
        ),
        Positioned(
            bottom: _media_Q.height * .15,
            left: _media_Q.width * .35,
            // width: _media_Q.width * .6,
            // height: _media_Q.height * 0.08,
            // child: Placeholder(),
            child: Text("By Zeta  🌀")),
      ]),
    );
  }
}
