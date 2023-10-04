import 'dart:convert';

import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/models/user.dart';
import 'package:chit_chat/screens/profile_Screen.dart';
import 'package:chit_chat/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  List<chatUUser_Info> _list_UserInfo = [];
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(_list_UserInfo[0]),
              ),
            ),
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      //
      body: StreamBuilder(
        stream: Apis.fireStrore.collection("users").snapshots(),
        builder: (context, snapshot) {
          final dataFromSnap = snapshot.data?.docs;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              _list_UserInfo = dataFromSnap!
                      .map((e) => chatUUser_Info.mapJsonToModelObject(e.data()))
                      .toList() ??
                  [];
          }
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;
            print("Date from firestore : ${jsonEncode(data[0].data())}");
          }
          if (_list_UserInfo.isNotEmpty) {
            return ListView.builder(
              itemCount: _list_UserInfo.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return chatUserCard(_list_UserInfo[index]);
              },
            );
          } else {
            return Center(
              child: Text("Network not available"),
            );
          }
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
