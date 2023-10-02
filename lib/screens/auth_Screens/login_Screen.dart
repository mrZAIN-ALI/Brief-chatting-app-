import 'dart:io';

import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/helpers/dialogs.dart';
import 'package:chit_chat/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (err) {
      print("_signInWithGoogle : $err");
      DialogHelper.showSnackBar(context, "Something went wrong check internet");
      return null;
    }
  }

  void _trySignIn() {
    DialogHelper.showProgressIndicator(context);
    _signInWithGoogle().then(
      (userCredentials) async {
        Navigator.of(context).pop();
        if (userCredentials != null) {
          // print(userCredentials.additionalUserInfo);
          // print(userCredentials.user);
          if ((await Apis.userExists())) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => homeScreen(),
              ),
            );
          } else {
            Apis.createUser().then(
              (value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homeScreen(),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  bool _isAnim_Done = false;
  //
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        setState(() {
          _isAnim_Done = true;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _media_Q = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcom to Chit Chat"),
      ),
      body: Stack(children: [
        AnimatedPositioned(
          duration: Duration(seconds: 1),
          left: _isAnim_Done ? _media_Q.width * .25 : -_media_Q.width * 5,
          top: _media_Q.height * .15,
          width: _media_Q.width * .5,
          child: Image.asset(
            "assets/images/icon/icon.png",
          ),
        ),
        Positioned(
          bottom: _media_Q.height * .15,
          left: _media_Q.width * .20,
          width: _media_Q.width * .6,
          height: _media_Q.height * 0.08,
          // child: Placeholder(),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.green[100],
            label: Text(
              "Sign In",

              style: Theme.of(context).textTheme.bodyMedium,
              // TextStyle(
              //   fontFamily: ,
              //   fontSize: 30,
              //   color: Colors.black,
              // ),
            ),
            onPressed: () {
              _trySignIn();
            },
            icon: Flexible(
              child: Image.asset(
                "assets/images/google.png",
                width: _media_Q.width * .20,
                height: _media_Q.height * .25,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
