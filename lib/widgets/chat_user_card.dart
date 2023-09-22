import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  const chatUserCard({super.key});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  @override
  Widget build(BuildContext context) {
    //
    final mdeiaQ=MediaQuery.of(context).size;
    //
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mdeiaQ.width *0.03, vertical: 3),
      color: Colors.transparent,
      child: InkWell(
        onTap: () => print("object"),
        child: ListTile(
          
          // textColor: Colors.amber,
          leading: CircleAvatar(child: Placeholder()),
          title: Text("Friend Name"),
          subtitle: Text("status of msg + msg",maxLines: 1,),
          trailing: Text("10:22 PM"),
        ),
      ),
    );
  }
}
