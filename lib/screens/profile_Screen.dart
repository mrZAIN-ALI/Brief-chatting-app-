import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  final chatUUser_Info user_Info;
  const ProfileScreen(this.user_Info);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode aboutFocusNode = FocusNode();
  @override
  void dispose() {
    nameFocusNode.dispose();
    aboutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final mediaQ = MediaQuery.of(context).size;
    final heightForCircularImage = mediaQ.height * 0.20;
    final primaryThemeColor = Theme.of(context).colorScheme.primary;
    //
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home_outlined),
        title: Text("User Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: mediaQ.height * 0.020,
              width: mediaQ.width,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(heightForCircularImage / 2),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: heightForCircularImage,
                width: heightForCircularImage,
                imageUrl: widget.user_Info.image ??
                    "http://via.placeholder.com/350x150",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    Icon(CupertinoIcons.person),
              ),
            ),
            //
            SizedBox(
              height: mediaQ.height * 0.020,
            ),
            Text(widget.user_Info.email,
                style: TextStyle(color: Colors.black54)),
            //
            SizedBox(
              height: mediaQ.height * 0.040,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: nameFocusNode,
                initialValue: widget.user_Info.name,
                // style: TextStyle(
                //   color: nameFocusNode.hasFocus ? primaryThemeColor : Colors.black,
                // ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: nameFocusNode.hasFocus
                          ? primaryThemeColor
                          : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: primaryThemeColor,
                    ),
                  ),
                  hintText: "i.e : John Smith",
                  prefixIcon: Icon(
                    CupertinoIcons.person,
                    color: nameFocusNode.hasFocus
                        ? primaryThemeColor
                        : Colors.black54,
                    // color: primaryThemeColor,
                  ),
                  labelText: "Name",
                  labelStyle: TextStyle(
                    color: nameFocusNode.hasFocus
                        ? primaryThemeColor
                        : Colors.black54,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  // When clicking on the first text field, unfocus the second one
                  aboutFocusNode.unfocus();
                },
              ),
            ),
            //
            SizedBox(
              height: mediaQ.height * 0.020,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: aboutFocusNode,
                initialValue: widget.user_Info.about,
                // style: TextStyle(
                //   color: aboutFocusNode.hasFocus ? primaryThemeColor : Colors.black,
                // ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: aboutFocusNode.hasFocus
                          ? primaryThemeColor
                          : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: primaryThemeColor,
                    ),
                  ),
                  hintText: "i.e : John Smith",
                  prefixIcon: Icon(
                    CupertinoIcons.info,
                    color: aboutFocusNode.hasFocus
                        ? primaryThemeColor
                        : Colors.black54,
                  ),
                  labelText: "About",
                  labelStyle: TextStyle(
                    color: aboutFocusNode.hasFocus
                        ? primaryThemeColor
                        : Colors.black54,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  // When clicking on the second text field, unfocus the first one
                  nameFocusNode.unfocus();
                },
              ),
            ),
            //
            SizedBox(
              height: mediaQ.height * 0.050,
            ),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text("Update Profile"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(mediaQ.width * 0.7, mediaQ.height * .06),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(15),
                    // ),
                    shape: StadiumBorder()))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.logout),
        backgroundColor: Colors.white,
        foregroundColor: primaryThemeColor,
      ),
    );
  }
}
