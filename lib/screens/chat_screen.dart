import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chit_chat/helpers/dateFormtingUtil.dart';
import 'package:chit_chat/models/user.dart';
import 'package:chit_chat/screens/secondPlayerProfile_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/foundation.dart' as foundation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/helpers/dialogs.dart';
import 'package:chit_chat/widgets/messageCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final secondPlayer;
  const ChatScreen(this.secondPlayer);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //
  bool _isEmojiPickerOn = false;
  bool _isUploading = false;
  List<Messages> _listofMessages = [];
  final TextEditingController _mesgFieldController = TextEditingController();
  //
  Widget _customizeAppbar() {
    //
    final mediaQ = MediaQuery.of(context).size;
    //
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => secondPlayerProfile(widget.secondPlayer),
          ),
        );
      },
      child: StreamBuilder(
        stream: Apis.get_UserInfo(widget.secondPlayer),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data!.docs;
          final list_ = data
              .map((e) => chatUUser_Info.mapJsonToModelObject(e.data()))
              .toList();

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    (mediaQ.height * 0.05) / 2), // Make it a circle
                child: CachedNetworkImage(
                  height: mediaQ.height * 0.05,
                  width: mediaQ.height * 0.05, // Make the width equal to height
                  imageUrl: list_.isNotEmpty
                      ? list_[0].image
                      : widget.secondPlayer.image ??
                          "http://via.placeholder.com/350x150",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) =>
                      Icon(CupertinoIcons.person),
                ),
              ),
              SizedBox(
                width: mediaQ.width * 0.05,
              ),
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    list_.isNotEmpty ? list_[0].name : widget.secondPlayer.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    list_.isNotEmpty
                        ? list_[0].isOnline
                            ? "Online"
                            : DateFormatUtil.formatLastActiveTime(
                                context: context,
                                lastActive: list_[0].lastActive,
                              )
                        : DateFormatUtil.formatLastActiveTime(
                            context: context,
                            lastActive: widget.secondPlayer.lastActive,
                          ),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  //for innput of user
  Widget renderUserInput() {
    final mediaQ = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mediaQ.height * 0.01, horizontal: mediaQ.width * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                // textBaseline: TextBaseline.alphabetic,
                // crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      _isEmojiPickerOn = !_isEmojiPickerOn;
                      FocusScope.of(context).unfocus();
                    }),
                    icon: Icon(Icons.emoji_emotions_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _mesgFieldController,
                      onTap: () {
                        setState(() {
                          if (_isEmojiPickerOn) {
                            _isEmojiPickerOn = false;
                          }
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFFA8DF8E),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Picking multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      // uploading & sending image one by one
                      for (var i in images) {
                        setState(() => _isUploading = true);
                        await Apis.sendPhoto_msg(
                          File(i.path),
                          widget.secondPlayer,
                        );
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: Icon(Icons.photo),
                  ),
                  IconButton(
                    onPressed: () => _takeImageFromCamera(),
                    icon: Icon(Icons.camera_alt),
                  ),
                  //
                ],
              ),
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
            // padding: EdgeInsets.all(0),
            minWidth: 0,
            onPressed: () {
              // print("object");
              if (_mesgFieldController.text.isNotEmpty) {
                Apis.sendMessage(widget.secondPlayer, _mesgFieldController.text,
                    msgType.text);
                _mesgFieldController.text = "";
              } else {
                return null;
              }
            },
            child: Icon(
              Icons.send,
              color: Color(0xFFA8DF8E),
              size: 28,
            ),
            color: Colors.white,
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }

  //
  Widget renderChatBody() {
    List<Messages> list = [];
    return Expanded(
      child: StreamBuilder(
        stream: Apis.getMessages(widget.secondPlayer),
        builder: (context, snapshot) {
          final dataFromSnap = snapshot.data?.docs;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return const Center(
                child: Center(child: Text("Start Chating ")),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              // print("Printing Messeges get from api.getMessages(widget.secondPlayer)"+jsonEncode(dataFromSnap![0].data()));
              list = dataFromSnap!
                      .map((e) => Messages.fromJson(e.data()))
                      .toList() ??
                  [];
          }
          // if (snapshot.hasData) {
          //   // final data = snapshot.data!.docs;
          //   // print("Date from firestore : ${jsonEncode(data[0].data())}");
          // }
          if (list.isNotEmpty) {
            return ListView.builder(
              reverse: true,
              itemCount: list.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                // print("Sending messages to message Card Widget"+list[index].msg);
                // list[index].msg ?? Print("Message is null"):
                return MessageCard(list[index]);
              },
            );
          } else {
            return Center(
              child: Text("Start Chating"),
            );
          }
        },
      ),
    );
  }

  Widget _showEmojiPicker() {
    return Offstage(
      offstage: !_isEmojiPickerOn,
      child: SizedBox(
          height: 250,
          child: emoji.EmojiPicker(
            textEditingController: _mesgFieldController,
            // onBackspacePressed: _onBackspacePressed,
            config: emoji.Config(
              columns: 7,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.30
                      : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: emoji.Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Theme.of(context).primaryColor,
              iconColor: Colors.grey,
              iconColorSelected: Theme.of(context).primaryColor,
              backspaceColor: Theme.of(context).primaryColor,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              recentTabBehavior: emoji.RecentTabBehavior.RECENT,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const emoji.CategoryIcons(),
              buttonMode: emoji.ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }

  //
  Future<void> _takeImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? picketImage_File =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (picketImage_File == null) {
      print("Image not recived from camera");
    } else {
      // setState(() {
      //   _imagePath = picketImage_File.path;
      // });
      Apis.sendPhoto_msg(
        File(picketImage_File.path),
        widget.secondPlayer,
      );
      // Navigator.of(context).pop();
    }
  }

  //
  Future<void> _takeMultipleImagesFromCamera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final List<XFile?> picketImage_File =
        await picker.pickMultiImage(imageQuality: 80);

    if (picketImage_File.isEmpty) {
      print("Image not recived from camera");
    } else {
      for (var i in picketImage_File) {
        Apis.sendPhoto_msg(
          File(i!.path),
          widget.secondPlayer,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(
          color: Color(0xFFA8DF8E),
        ),
      ),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_isEmojiPickerOn) {
              setState(() {
                _isEmojiPickerOn = !_isEmojiPickerOn;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: GestureDetector(
            onTap: () {
              _isEmojiPickerOn = !_isEmojiPickerOn;
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                appBar: AppBar(
                  // title: Text("Chit Chat"),
                  automaticallyImplyLeading: false,
                  flexibleSpace: _customizeAppbar(),
                ),
                body: Column(
                  children: [
                    renderChatBody(),
                    if(_isUploading)
                      Center(child: CircularProgressIndicator()),
                    renderUserInput(),
                    if (_isEmojiPickerOn) _showEmojiPicker(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
