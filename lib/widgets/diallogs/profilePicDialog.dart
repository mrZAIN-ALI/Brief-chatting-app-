import 'package:flutter/foundation.dart';
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
        height: mediaQ.height * 0.35,
        width: mediaQ.width * 0.60,
        child: Stack(
          children: [

          ],
        ),
      ),
    );
  }
}