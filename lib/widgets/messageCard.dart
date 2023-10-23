import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/helpers/dateFormtingUtil.dart';
import 'package:chit_chat/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final Messages message;
  const MessageCard(this.message);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  Widget _myMessage() {
    if(widget.message.fromId == widget.message.toId){
      Apis.updateMessageStatus(widget.message);
    }
    final mediaQ = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(left: mediaQ.width * 0.02),
          child: Column(
            children: [
              Text(
                DateFormatUtil.FormatDate(context: context, unfromatedDate: widget.message.sentTime),
                // DateTime.parse(widget.message.sentTime.toString()).toString(),
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              if(widget.message.readTime!=" ")
               Icon(
                Icons.done_all,
                color: Colors.blue,
                size: 20,)
            ],
          ),
        ),
        //
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mediaQ.width * 0.02),
            margin: EdgeInsets.symmetric(
              horizontal: mediaQ.width * 0.03,
              vertical: mediaQ.height * 0.01,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: widget.message.typeOfMsg == msgType.text ? Text(
                widget.message.msg ,
                style: TextStyle(fontSize: 18),
              ):
              ClipRRect(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: mediaQ.height*0.05,
                            width:mediaQ.height*0.05,
                            imageUrl: widget.message.msg,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(CupertinoIcons.photo),
                          ),
                        ), 
              
            ),
          ),
        ),
        //
      ],
    );
  }

  Widget _secondPlayer() {
    final mediaQ = MediaQuery.of(context).size;

    if(widget.message.readTime!=" "){
      Apis.updateMessageStatus( widget.message);
    }
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mediaQ.width * 0.02),
            margin: EdgeInsets.symmetric(
              horizontal: mediaQ.width * 0.03,
              vertical: mediaQ.height * 0.01,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade600,
                width: 2,
              ),
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.message.msg ,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        //
        Padding(
          padding: EdgeInsets.only(left: mediaQ.width * 0.02),
          child: Column(
            children: [
              Text(
                DateFormatUtil.FormatDate(context: context, unfromatedDate: widget.message.sentTime),
                // DateTime.parse(widget.message.sentTime.toString()).toString(),
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              if(widget.message.readTime!=" ")
               Icon(
                Icons.done_all,
                color: Colors.blue,
                size: 20,)
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Apis.me_LoggedIn.id == widget.message.fromId
        ? _myMessage()
        : _secondPlayer();
  }
}
