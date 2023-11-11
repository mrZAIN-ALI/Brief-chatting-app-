import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/screens/secondPlayerProfile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profilePicDialog extends StatefulWidget {
  final secondPlayer;
  const profilePicDialog({required this.secondPlayer});
  @override
  State<profilePicDialog> createState() => _profilePicDialogState();
}

class _profilePicDialogState extends State<profilePicDialog> {
  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: mediaQ.height * 0.40,
        width: mediaQ.width * 0.60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    (mediaQ.height * 0.15)), // Make it a circle
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: mediaQ.height * 0.3,
                  width: mediaQ.height * 0.3, // Make the width equal to height
                  imageUrl: widget.secondPlayer.image ??
                      "http://via.placeholder.com/350x150",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) =>
                      Icon(CupertinoIcons.person),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.secondPlayer.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return secondPlayerProfile(widget.secondPlayer);
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
