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
          IconButton(onPressed: null, icon: Icon(Icons.search),),
          IconButton(onPressed: () => print("hh"), icon: Icon(Icons.more_vert),),
        ],
      ),
      body: Center(
        child: Text("data"),
      ),
      //
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15,right: 15),
        child: FloatingActionButton(onPressed: () {
          
        },child: Icon(Icons.add_comment),),
      ),
    );
  }
}
