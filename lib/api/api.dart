import 'dart:io' show File;

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
  static final current_User = auth.currentUser;
  //
  static late chatUUser_Info me_LoggedIn;
  //
  static Future<bool> userExists() async {
    return (await fireStrore.collection("users").doc(current_User!.uid).get())
        .exists;
  }

  //
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = chatUUser_Info(
      image: current_User!.photoURL.toString(),
      lastActive: time,
      name: current_User!.displayName.toString(),
      about: "bhag jao",
      createdAt: time,
      id: current_User!.uid ?? "id",
      pushToken: "unkniwn right now",
      email: current_User!.email.toString(),
      isOnline: true,
    );
    print("Creating user");
    return await fireStrore.collection("users").doc(current_User!.uid).set(
          chatUser.getJsonFormat(),
        );
  }

  //
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAlusers() {
    return Apis.fireStrore.collection("users").snapshots();
  }

  //
  static Future<void> getLoggedInUserInfo() async {
    // current_User ?? await auth.currentUser;
    await fireStrore
        .collection("users")
        .doc(current_User!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        print("Error ku a rha h ");
        me_LoggedIn = chatUUser_Info.mapJsonToModelObject(user.data()!);
      } else {
        await createUser().then((value) => getLoggedInUserInfo());
        print("creating user user not exist ");
      }
    });
    // print("Data from firestore : ${data.data()}");
  }

  //
  static Future<void> updateUserInfo() async {
    await fireStrore.collection("users").doc(current_User!.uid).update({
      "name": me_LoggedIn.name,
      "about": me_LoggedIn.about,
    });
  }

  //
  static Future<void> updateProfileImage(File file) async {
    final fileExtenstion = file.path.split(".").last;
    //refering storage locaiton on fitrebase
    final ref = storage_FirebaseSrg.ref().child(
        "profileImages/${current_User!.uid}/profileImage.$fileExtenstion");
    //uploading file to firebase storage
    await ref.putFile(
      file,
      SettableMetadata(contentType: "image/$fileExtenstion"),
    );
    //getting download url
    me_LoggedIn.image = await ref.getDownloadURL();
    //updating user info
    final log =
        await fireStrore.collection("users").doc(current_User!.uid).update({
      "image": me_LoggedIn.image,
    });
  }

  //
  static String getUniqueChatID(String id2) {
    return current_User!.uid.hashCode <= id2.hashCode
        ? "${current_User!.uid} + $id2"
        : "$id2 + ${current_User!.uid}";
  }

  //
  //Fetchign MEssages
  //asdadasds
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      chatUUser_Info user) {
    try {
      final snap = fireStrore
          .collection("chats/${getUniqueChatID(user.id)}/messages/")
          .snapshots();
      print("Getting messages");
      return snap;
    } catch (e) {
      print("Error while fetching messages : $e");
    }
    return {} as Stream<QuerySnapshot<Map<String, dynamic>>>; //returning empty
  }

  //Sending message
  static Future<void> sendMessage(chatUUser_Info reciverr, String msg,msgType type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    Messages messageObj = Messages(
        fromId: me_LoggedIn.id,
        msg: msg,
        sentTime: time,
        toId: reciverr.id,
        typeOfMsg: type,
        readTime: " ");

    final ref = fireStrore
        .collection("chats/${getUniqueChatID(reciverr.id)}/messages/");
    final jsonFormtOfMsg = messageObj.toJson();

    try {
      await ref.doc(time).set(jsonFormtOfMsg);
      print("Message Sent");
    } catch (e) {
      print("Error while sending message : $e");
    }
  }

  //Udaitn message status
  static Future<void> updateMessageStatus(Messages msg) async {
    final ref =
        fireStrore.collection("chats/${getUniqueChatID(msg.fromId)}/messages/");
    await ref.doc(msg.sentTime).update({
      "readTime": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //get last sent or recieved message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastmessage(
      chatUUser_Info user) {
    try {
      final snap = fireStrore
          .collection("chats/${getUniqueChatID(user.id)}/messages/")
          .limit(1)
          .orderBy("sentTime", descending: true)
          .snapshots();
      print("Getting last message");
      return snap;
    } catch (e) {
      print("Error while fetching messages : $e");
    }
    return {} as Stream<QuerySnapshot<Map<String, dynamic>>>; //returning empty
  }

  //send image

  static Future<void> sendPhoto_msg(File file,chatUUser_Info secondPlayer) async {
    final fileExtenstion = file.path.split(".").last;
    //refering storage locaiton on fitrebase
    final ref = storage_FirebaseSrg.ref().child(
        "Imgaes/${getUniqueChatID(secondPlayer.id)}/${DateTime.now().millisecondsSinceEpoch}.$fileExtenstion");
    //uploading file to firebase storage
    await ref.putFile(file,SettableMetadata(contentType: "image/$fileExtenstion"));
    //getting download url
    final imageUrl=await ref.getDownloadURL();
    //sending message
    await sendMessage(secondPlayer, imageUrl,msgType.image);
  }
}
