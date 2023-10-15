import 'dart:io';

import 'package:chit_chat/models/message.dart';
import 'package:chit_chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  //
  static final FirebaseFirestore fireStrore = FirebaseFirestore.instance;
  //
  static final FirebaseStorage storage_FirebaseSrg = FirebaseStorage.instance;
  //
  static final _current_User = auth.currentUser;
  //
  static late chatUUser_Info me_LoggedIn;
  //
  static Future<bool> userExists() async {
    return (await fireStrore.collection("users").doc(_current_User!.uid).get())
        .exists;
  }

  //
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = chatUUser_Info(
      image: _current_User!.photoURL.toString(),
      lastActive: time,
      name: _current_User!.displayName.toString(),
      about: "bhag jao",
      createdAt: time,
      id: "id",
      pushToken: "unkniwn right now",
      email: _current_User!.email.toString(),
      isOnline: true,
    );
    return await fireStrore.collection("users").doc(_current_User!.uid).set(
          chatUser.getJsonFormat(),
        );
  }

  //
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAlusers() {
    return Apis.fireStrore.collection("users").snapshots();
  }

  //
  static Future<void> getLoggedInUserInfo() async {
    await fireStrore
        .collection("users")
        .doc(_current_User!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me_LoggedIn = chatUUser_Info.mapJsonToModelObject(user.data()!);
      } else {
        await createUser().then((value) => getLoggedInUserInfo());
      }
    });
    // print("Data from firestore : ${data.data()}");
  }

  //
  static Future<void> updateUserInfo() async {
    await fireStrore.collection("users").doc(_current_User!.uid).update({
      "name": me_LoggedIn.name,
      "about": me_LoggedIn.about,
    });
  }

  //
  static Future<void> updateProfileImage(File file) async {
    final fileExtenstion = file.path.split(".").last;
    //refering storage locaiton on fitrebase
    final ref = storage_FirebaseSrg.ref().child(
        "profileImages/${_current_User!.uid}/profileImage.$fileExtenstion");
    //uploading file to firebase storage
    await ref.putFile(
      file,
      SettableMetadata(contentType: "image/$fileExtenstion"),
    );
    //getting download url
    me_LoggedIn.image = await ref.getDownloadURL();
    //updating user info
    final log =
        await fireStrore.collection("users").doc(_current_User!.uid).update({
      "image": me_LoggedIn.image,
    });
  }


  //
  static String getUniqueChatID(String id2) {
    return _current_User!.uid.hashCode <= id2.hashCode
        ? "${_current_User!.uid} + $id2"
        : "$id2 + ${_current_User!.uid}";
  }
  //
  //
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(chatUUser_Info user) {
    return fireStrore.collection("chats/${getUniqueChatID(user.id)}/messages").snapshots();
  }
  //
  static Future<void> sendMessage(chatUUser_Info reciverr , String msg) async{
    final time=DateTime.now().millisecondsSinceEpoch.toString(); 

    final messageObj= Messages(
      fromId: me_LoggedIn.id,
      msg: msg,
      sentTime: time,
      toId: reciverr.id,
      typeOfMsg: msgType.text,
      readTime: " "
    );

    final ref = fireStrore.collection("chats/${getUniqueChatID(reciverr.id)}/messages");
    await ref.doc(time).set(messageObj.toJson()); 
  }

}
