import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/models/message.dart';
import 'package:chit_chat/models/user.dart';
import 'package:chit_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class chatUserCard extends StatefulWidget {
  final _chatUser_info;
  const chatUserCard(this._chatUser_info);

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  //if this message is null means not latest message from second player
  Messages?  _tempMessage;
  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mediaQ.width * 0.03, vertical: 3),
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatScreen(widget._chatUser_info);
          },));
        },
        child: StreamBuilder(

          stream: Apis.getLastmessage(widget._chatUser_info),
          builder: (context, snapshot) {
            // snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),):null;
            final dataFromSnap=snapshot.data!.docs;
            final list=dataFromSnap.map((e) => Messages.fromJson(e.data())).toList();
            if(list.isNotEmpty){
              _tempMessage=list[0];
            }
            // if(dataFromSnap.first.exists && dataFromSnap.isNotEmpty){

            //   _tempMessage=Messages.fromJson(dataFromSnap.first.data()); 
            // }
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                    (mediaQ.height * 0.05) / 2), // Make it a circle
                child: CachedNetworkImage(
                  height: mediaQ.height * 0.05,
                  width: mediaQ.height * 0.05, // Make the width equal to height
                  imageUrl: widget._chatUser_info.image ??
                      "http://via.placeholder.com/350x150",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
                ),
              ),
              title: Text(widget._chatUser_info.name),
              subtitle: Text(
                "status of msg + msg",
                maxLines: 1,
              ),
              // trailing: Text("10:22 PM"),
              trailing: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
        
                color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
