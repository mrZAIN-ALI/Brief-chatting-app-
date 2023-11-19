import 'dart:convert';
import 'dart:io' show File, HttpHeaders;

import 'package:chit_chat/models/message.dart';
import 'package:chit_chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  //
  static final FirebaseFirestore fireStrore = FirebaseFirestore.instance;
  //
  static final FirebaseStorage storage_FirebaseSrg = FirebaseStorage.instance;
  //
  static final current_User = auth.currentUser;
  //
  static late chatUUser_Info me_LoggedIn;
  //
  static FirebaseMessaging f_messageing = FirebaseMessaging.instance;
  //
  static Future<void> getFCM_Token() async {
    await f_messageing.requestPermission();
     f_messageing.getToken().then((value) {
      if (value != null) {
        UpdateFCMTOken(value);
        me_LoggedIn.pushToken = value;
        print("FCM Token : ${me_LoggedIn.pushToken}");
      }
    });
  }

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
      pushToken: "same As",
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
        // print("Error ku a rha h ");
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
  // AIK AUR CHIK CHIK OF CN LAB
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      chatUUser_Info user) {
    try {
      final snap = fireStrore
          .collection("chats/${getUniqueChatID(user.id)}/messages/")
          .orderBy("sentTime", descending: true)
          .snapshots();
      print("Getting messages");
      return snap;
    } catch (e) {
      print("Error while fetching messages : $e");
    }
    return {} as Stream<QuerySnapshot<Map<String, dynamic>>>; //returning empty
  }

  //Sending message
  static Future<void> sendMessage(
      chatUUser_Info reciverr, String msg, msgType type) async {
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
      await ref.doc(time).set(jsonFormtOfMsg).then(
            (value) => sendPushNotification(
                reciverr, type == msgType.text ? msg : "Image"),
          );
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

  static Future<void> sendPhoto_msg(
      File file, chatUUser_Info secondPlayer) async {
    final fileExtenstion = file.path.split(".").last;
    //refering storage locaiton on fitrebase
    final ref = storage_FirebaseSrg.ref().child(
        "Imgaes/${getUniqueChatID(secondPlayer.id)}/${DateTime.now().millisecondsSinceEpoch}.$fileExtenstion");
    //uploading file to firebase storage
    await ref.putFile(
        file, SettableMetadata(contentType: "image/$fileExtenstion"));
    //getting download url
    final imageUrl = await ref.getDownloadURL();
    //sending message
    await sendMessage(secondPlayer, imageUrl, msgType.image);
  }

  //GET user information
  static Stream<QuerySnapshot<Map<String, dynamic>>> get_UserInfo(
    secondPlayer,
  ) {
    return Apis.fireStrore
        .collection("users")
        .where("id", isEqualTo: secondPlayer.id)
        .snapshots();
  }

  //update active status of user
  static Future<void> updateActiveStatus(bool stat) {
    // print("Form updateActiveStatus : Updating pushtoken : ${me_LoggedIn.pushToken}");
    //
    return fireStrore.collection("users").doc(current_User!.uid).update({
      "isOnline": stat,
      "lastActive": DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  //update Fcm toekn of user
  static Future<void> UpdateFCMTOken(String token) {
    print(
        "Form UpdateFCMTOken : Updating pushtoken : ${token}");
    //
    return fireStrore.collection("users").doc(current_User!.uid).update({
      // "isOnline": stat,
      // "lastActive": DateTime.now().millisecondsSinceEpoch.toString(),
      "push_token": token ?? "Yr abhi tk ni mila",
    });
  }

  //for sending push notifation of message sen to secondplyaer
  static Future<void> sendPushNotification(
      chatUUser_Info secondPlayer, String msg) async {
    try {
      print(
          "I am printing push token of second player : ${secondPlayer.pushToken}");
      final body = {
        "to": secondPlayer.pushToken,
        "notification": {"title": secondPlayer.name, "body": msg},
      };
      var resoponse = await post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              "key=AAAA3v9gqd8:APA91bFEgFC4Ts2yrpjO30TKoIEU2_I94WAi66whT4AFmGxVKFpE8D_z_es-Jo9UtcXRBMjxB20qD7YQnZyu2861A9ZsEy9u7N_GeVuIJkQxfIzaf3w6dhMv7g7DUhnzbumyk_QEhoaW",
        },
        body: jsonEncode(body),
      );
      print("Resoponse staus : ${resoponse.statusCode}");
      print("Resoponse body : ${resoponse.body}");
    } catch (e) {
      print(
          "[[[[sendPushNotification]]]]    :Error while sending push notification : $e");
    }
  }
}
