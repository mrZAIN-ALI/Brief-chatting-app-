import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final secondPlayer;
  const ChatScreen(this.secondPlayer);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget _customizeAppbar() {
    //
    final mediaQ = MediaQuery.of(context).size;
    //
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
            imageUrl: widget.secondPlayer.image ??
                "http://via.placeholder.com/350x150",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
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
              widget.secondPlayer.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Lat Seen Not available HEH",
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
  }

  //for innput of user
  Widget renderUserInput() {
    final mediaQ = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: mediaQ.height*0.01,horizontal: mediaQ.width*0.02),
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
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions_outlined),
                  ),
                  Expanded(
                    child: TextField(
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
                    onPressed: () {},
                    icon: Icon(Icons.photo),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt),
                  ),
                  //
                ],
              ),
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.only(left: 10, right: 5,top: 10,bottom: 10),
            // padding: EdgeInsets.all(0),
            minWidth: 0,          
            onPressed: () {
              print("object");
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
  Widget renderChatBody(){
    return 
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
        child: Scaffold(
            appBar: AppBar(
              // title: Text("Chit Chat"),
              automaticallyImplyLeading: false,
              flexibleSpace: _customizeAppbar(),
            ),
            body: Column(
              children: [
                renderUserInput(),
              ],
            )),
      ),
    );
  }
}
