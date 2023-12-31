import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/helpers/dialogs.dart';
import 'package:chit_chat/models/user.dart';
import 'package:chit_chat/screens/auth_Screens/login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final chatUUser_Info user_Info;
  const ProfileScreen(this.user_Info);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode aboutFocusNode = FocusNode();
  final _textFormKey = GlobalKey<FormState>();
  String _imagePath = "empty";
  bool _isUploading = false;
  //
  Widget makeSomeVerticalSpace(double he) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * he,
    );
  }

  void _takeImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? picketImage_File =
        await picker.pickImage(source: ImageSource.gallery);

    if (picketImage_File != null) {
      setState(() {
        _imagePath = picketImage_File.path;
        _isUploading = true;
      });

      await Apis.updateProfileImage(File(picketImage_File.path)).then(
        (value) {
           DialogHelper.showSnackBar_Normal(
          context, "Profile Image Updated Successfully");
        },
      );

               Navigator.of(context).pop();
     
    }
  }

  void _takeImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? picketImage_File =
        await picker.pickImage(source: ImageSource.camera);

    if (picketImage_File == null) {
      print("Image not recived from camera");
    } else {
      setState(() {
        _imagePath = picketImage_File.path;
      });
      Apis.updateProfileImage(File(picketImage_File.path)).then(
        (value) {

         DialogHelper.showSnackBar_Normal(
            context, "Profile Image Updated Successfully");}
      );
      Navigator.of(context).pop();

    }
  }

  void _showBottomSheet() {
    final media_Q = MediaQuery.of(context).size;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      showDragHandle: true,
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: media_Q.height * 0.02),
              child: Text(
                "Pick a Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: media_Q.height * 0.03,
                      horizontal: media_Q.width * 0.02),
                  child: ElevatedButton(
                    onPressed: () {
                      _takeImageFromGallery();
                    },
                    child: Image.asset(
                      "assets/images/add_image.png",
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.white,
                      fixedSize:
                          Size(media_Q.width * 0.3, media_Q.height * 0.15),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _takeImageFromCamera(),
                  child: Image.asset(
                    "assets/images/camera.png",
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(media_Q.width * 0.3, media_Q.height * 0.15),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  //

  @override
  Widget build(BuildContext context) {
    //
    final primaryThemeColor = Theme.of(context).colorScheme.primary;
    final mediaQ = MediaQuery.of(context).size;
    final heightForCircularImage = mediaQ.height * 0.20;
    final nameFieldColor =
        nameFocusNode.hasFocus ? primaryThemeColor : Colors.black54;
    final aboutFieldColor =
        aboutFocusNode.hasFocus ? primaryThemeColor : Colors.black54;
    //
    return GestureDetector(
      onTap: () {
        FocusNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.home_outlined),
          title: Text("User Profile"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: mediaQ.height * 0.020,
                width: mediaQ.width,
              ),
              Stack(
                children: [
                  _imagePath != "empty"
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(heightForCircularImage / 2),
                          child: Image.file(
                            File(_imagePath),
                            fit: BoxFit.cover,
                            height: heightForCircularImage,
                            width: heightForCircularImage,
                          ),
                        )
                      : ClipRRect(
                          borderRadius:
                              BorderRadius.circular(heightForCircularImage / 2),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: heightForCircularImage,
                            width: heightForCircularImage,
                            imageUrl: widget.user_Info.image ??
                                "http://via.placeholder.com/350x150",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(CupertinoIcons.person),
                          ),
                        ),
                  Positioned(
                    child: MaterialButton(
                      onPressed: () {
                        _showBottomSheet();
                      },
                      child: Icon(
                        Icons.edit,
                        color: primaryThemeColor,
                      ),
                      color: Colors.white,
                      shape: CircleBorder(),
                    ),
                    bottom: 0,
                    right: 0,
                    // left: 4,
                  ),
                ],
              ),
              makeSomeVerticalSpace(0.02),

              //
              Text(
                widget.user_Info.email,
                style: TextStyle(color: Colors.black54 , fontSize: 20),
              ),
              //
              makeSomeVerticalSpace(0.04),

              //
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _textFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        // onTap: ()=>nameFocusNode.requestFocus(),
                        focusNode: nameFocusNode,
                        keyboardType: TextInputType.name,
                        initialValue: widget.user_Info.name ?? "Default Value",
                        onSaved: (newValue) => Apis.me_LoggedIn.name =
                            newValue! ?? "Default Value by zain",
                        validator: (value) => (value!.isEmpty && value != null)
                            ? "Name can't be empty"
                            : null,
                        // style: TextStyle(
                        //   color: nameFocusNode.hasFocus ? primaryThemeColor : Colors.black,
                        // ),
                        onEditingComplete: () {
                          setState(() {
                            nameFocusNode.unfocus();
                            aboutFocusNode.requestFocus();
                          });
                        },
                        onTap: () {
                          setState(() {
                            aboutFocusNode.unfocus();
                            nameFocusNode.requestFocus();
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: nameFieldColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: primaryThemeColor,
                            ),
                          ),
                          hintText: "i.e : John Smith",
                          prefixIcon:
                              Icon(CupertinoIcons.person, color: nameFieldColor
                                  // color: primaryThemeColor,
                                  ),
                          labelText: "Name",
                          labelStyle: TextStyle(color: nameFieldColor),
                        ),
                      ),
                      //
                      makeSomeVerticalSpace(0.03),

                      TextFormField(
                        focusNode: aboutFocusNode,
                        keyboardType: TextInputType.name,
                        initialValue: widget.user_Info.about ?? "Default Value",
                        onSaved: (newValue) => Apis.me_LoggedIn.about =
                            newValue! ?? "Default Value by zain",
                        validator: (value) => (value!.isEmpty && value != null)
                            ? "Name can't be empty"
                            : null,
                        // onEditingComplete: () {
                        //   aboutFocusNode.unfocus();

                        // },
                        onTap: () {
                          setState(() {
                            nameFocusNode.unfocus();
                            aboutFocusNode.requestFocus();
                          });
                        },
                        // style: TextStyle(
                        //   color: nameFocusNode.hasFocus ? primaryThemeColor : Colors.black,
                        // ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: aboutFieldColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: aboutFieldColor,
                            ),
                          ),
                          hintText: "i.e : Loves to Eat",
                          prefixIcon:
                              Icon(CupertinoIcons.info, color: aboutFieldColor
                                  // color: primaryThemeColor,
                                  ),
                          labelText: "About",
                          labelStyle: TextStyle(
                            color: aboutFieldColor,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      //
                      makeSomeVerticalSpace(0.04),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_textFormKey.currentState!.validate()) {
                            _textFormKey.currentState!.save();
                            Apis.updateUserInfo().then((value) {
                              DialogHelper.showSnackBar_Normal(
                                  context, "Profile Updated Successfully");
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        icon: Icon(Icons.edit),
                        label: Text("Update Profile"),
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(mediaQ.width * 0.7, mediaQ.height * .06),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(15),
                            // ),
                            shape: StadiumBorder()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Apis.updateActiveStatus(false);
            //
            DialogHelper.showProgressIndicator(context);
            await Apis.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                //
                Apis.auth =FirebaseAuth.instance;
                //
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
                //
              });
            });
          },
          child: Icon(Icons.logout),
          backgroundColor: Colors.white,
          foregroundColor: primaryThemeColor,
        ),
      ),
    );
  }
}
