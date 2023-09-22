import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home_outlined),
        title: Text("Chit Chat"),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => print("hh"),
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      //
      body: ListView.builder(
        itemCount: 12,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return chatUserCard();
        },
      ),
      //
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 15),
        child: FloatingActionButton(
          onPressed: () {
            Apis.auth.signOut();
          },
          child: Icon(Icons.add_comment),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
