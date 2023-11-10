import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/helpers/dateFormtingUtil.dart';
import 'package:chit_chat/helpers/dialogs.dart';
import 'package:chit_chat/models/user.dart';
import 'package:chit_chat/screens/auth_Screens/login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class secondPlayerProfile extends StatefulWidget {
  final chatUUser_Info secondPlayer;
  const secondPlayerProfile(this.secondPlayer);

  @override
  State<secondPlayerProfile> createState() => _secondPlayerProfileState();
}

class _secondPlayerProfileState extends State<secondPlayerProfile> {
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
          title: Text(widget.secondPlayer.name ?? "Default Value"),
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
                            imageUrl: widget.secondPlayer.image ??
                                "http://via.placeholder.com/350x150",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(CupertinoIcons.person),
                          ),
                        ),
                ],
              ),
              makeSomeVerticalSpace(0.02),
              //
              Text(
                widget.secondPlayer.email,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              makeSomeVerticalSpace(0.02),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("About : "),
                  Text(
                    widget.secondPlayer.about,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              //
            ],
          ),
        ),
        //
        floatingActionButton: Container(
          width: mediaQ.width * 0.90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Joining Date : ", style: TextStyle(fontSize: 20)),
              Text(
                DateFormatUtil.formatLastMesgSentTime(
                  context: context,
                  unfromatedDate: widget.secondPlayer.createdAt,
                  showYear: true
                ),
                style: TextStyle(color: Colors.black54 , fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
