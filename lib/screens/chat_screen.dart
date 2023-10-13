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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chit Chat"),
      ),
      body: Center(
        child: Text("Chat "),
      ),
      );
  }
}