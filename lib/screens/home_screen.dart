import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/models/user.dart';
import 'package:chit_chat/screens/profile_Screen.dart';
import 'package:chit_chat/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//

class homeScreen extends StatefulWidget {
  // const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
  
}

class _homeScreenState extends State<homeScreen> {
  bool _is_Searching=false;
  //for string all users
  // final List<chatUUser_Info> _list=[];
  //For stroing searched items
  final List<chatUUser_Info> _searchList=[];

  List<chatUUser_Info> _list_UserInfo = [];

  void searchUserFromMainList(value){
    _searchList.clear();
    for(var i in _list_UserInfo){
        if(i.name.toLowerCase().contains(value.toLowerCase())|| i.email.toLowerCase().contains(value.toLowerCase())){
            setState(() {
              
            _searchList.add(i);
            });

        }
    }
  }
  //
  void initState(){
    super.initState();
    Apis.getLoggedInUserInfo(); 
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(_is_Searching){
          setState(() {
            _is_Searching=!_is_Searching;
            // _searchList.clear();
          });
          return Future.value(false);
        }else{
          return Future.value(true);

        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.home_outlined),
          title: _is_Searching ? TextField(
            decoration: InputDecoration(border: InputBorder.none,hintText:  "Name or Email",),
            autofocus: true,
            style: TextStyle(fontSize: 25),
            onChanged:  (value) {
              searchUserFromMainList(value);
            },
          ): Text("Chit Chat"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _is_Searching=!_is_Searching;
                  _searchList.clear();
                });
              },
              icon: Icon(_is_Searching ? CupertinoIcons.clear_circled : Icons.search),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(Apis.me_LoggedIn),
                ),
              ),
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        //
        body: StreamBuilder(
          stream: Apis.getAlusers(),
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
              // print("Date from firestore : ${jsonEncode(data[0].data())}");
            }
            if (_list_UserInfo.isNotEmpty) {
              return ListView.builder(
                itemCount: _is_Searching ? _searchList.length : _list_UserInfo.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return chatUserCard(_is_Searching ? _searchList[index] : _list_UserInfo[index]);
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
      ),
    );
  }
}
