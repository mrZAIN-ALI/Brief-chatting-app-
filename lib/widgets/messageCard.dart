import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/helpers/dateFormtingUtil.dart';
import 'package:chit_chat/models/message.dart' as m;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final m.Messages message;
  const MessageCard(this.message);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  //
  //
  Widget _myMessage() {
    if (widget.message.fromId == widget.message.toId) {
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
                DateFormatUtil.FormatDate(
                    context: context, unfromatedDate: widget.message.sentTime),
                // DateTime.parse(widget.message.sentTime.toString()).toString(),
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              if (widget.message.readTime != " ")
                Icon(
                  Icons.done_all,
                  color: Colors.blue,
                  size: 20,
                )
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
              child: widget.message.typeOfMsg == m.msgType.text
                  ? Text(
                      widget.message.msg,
                      style: TextStyle(fontSize: 18),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
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
            // child: Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: Text(
            //       widget.message.msg,
            //       style: TextStyle(fontSize: 18),
            //     )),
          ),
        ),
        //
      ],
    );
  }

  Widget _secondPlayer() {
    final mediaQ = MediaQuery.of(context).size;

    if (widget.message.readTime != " ") {
      Apis.updateMessageStatus(widget.message);
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
              child: widget.message.typeOfMsg == m.msgType.text
                  ? Text(
                      widget.message.msg,
                      style: TextStyle(fontSize: 18),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
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
        Padding(
          padding: EdgeInsets.only(left: mediaQ.width * 0.02),
          child: Column(
            children: [
              Text(
                DateFormatUtil.FormatDate(
                    context: context, unfromatedDate: widget.message.sentTime),
                // DateTime.parse(widget.message.sentTime.toString()).toString(),
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              if (widget.message.readTime != " ")
                Icon(
                  Icons.done_all,
                  color: Colors.blue,
                  size: 20,
                )
            ],
          ),
        ),
      ],
    );
  }

  //
  void _showBottomSheet(bool isME) {
    final media_Q = MediaQuery.of(context).size;
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
            //
            widget.message.typeOfMsg == m.msgType.text
                ? _OptionItem(
                    name: "Copy",
                    icon: Icons.copy_all_rounded,
                    onTapCallback: () {})
                : _OptionItem(
                    name: "Save Image",
                    icon: Icons.download_rounded,
                    onTapCallback: () {}),
            //
            Divider(
                color: Colors.grey,
                height: media_Q.height * 0.03,
                thickness: 2),
            if (widget.message.typeOfMsg == m.msgType.text && isME)
              _OptionItem(
                  name: "Edit Message", icon: Icons.edit, onTapCallback: () {}),
            if (isME)
              _OptionItem(
                  name: "Delete Message",
                  icon: Icons.delete_forever,
                  onTapCallback: () {}),
            if (isME)
              Divider(
                  color: Colors.grey,
                  height: media_Q.height * 0.03,
                  thickness: 2),
            _OptionItem(
                name: "Sent At ${DateFormatUtil.formatMessageSeenTime(
                  context: context,
                  messageSentTime: widget.message.sentTime,
                )}",
                icon: Icons.remove_red_eye_outlined,
                onTapCallback: () {}),
            _OptionItem(
                name: widget.message.readTime == " "? "Not Seen Yet"
                :"Read At ${DateFormatUtil.formatMessageSeenTime(
                  context: context,
                  messageSentTime: widget.message.readTime,
                )}",
                icon: Icons.remove_red_eye,
                onTapCallback: () {}),
          ],
        );
      },
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    final isMe = Apis.me_LoggedIn.id == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _myMessage() : _secondPlayer(),
    );
  }
}

class _OptionItem extends StatelessWidget {
  // const _OptionItem({super.key});
  final name;
  final icon;
  final Function onTapCallback;
  const _OptionItem(
      {required this.name, required this.icon, required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    //
    final mediaQ = MediaQuery.of(context).size;
    //
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        child: InkWell(
          onTap: () {
            onTapCallback();
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: mediaQ.width * 0.05,
              top: mediaQ.height * 0.015,
              bottom: mediaQ.height * 0.015,
            ),
            child: Row(
              children: [
                Icon(icon),
                Flexible(
                  child: Text(
                    
                    "  $name",
                    style: TextStyle(color: Colors.black54,fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
