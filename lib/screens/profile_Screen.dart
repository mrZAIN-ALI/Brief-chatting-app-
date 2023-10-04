import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final chatUUser_Info user_Info;
  const ProfileScreen(this.user_Info);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context).size;
    final height_forCircualrImage =
        mediaQ.height * 0.20; // Change the height here

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home_outlined),
        title: Text("User Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: mediaQ.height * 0.020,
              width: mediaQ.width,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(height_forCircualrImage / 2),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: height_forCircualrImage,
                width:
                    height_forCircualrImage, // Set both height and width to the same value
                imageUrl: widget.user_Info.image ??
                    "http://via.placeholder.com/350x150",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
              ),
            ),
      
            //
            SizedBox(
              height: mediaQ.height * 0.020,
            ),
            Text(widget.user_Info.email, style: TextStyle(color: Colors.black54)),
            //
            SizedBox(
              height: mediaQ.height * 0.020,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                
                initialValue: widget.user_Info.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: 
                  BorderSide(color: Color.fromARGB(255, 99, 43, 43))),
                  hintText: "i.e : John Smith",
                  prefixIcon: Icon(CupertinoIcons.person , color: Theme.of(context).colorScheme.primary,),
                  label: const Text("Name",style: TextStyle(fontSize: 25),),
                  fillColor: Theme.of(context).colorScheme.error,
                  
                ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
