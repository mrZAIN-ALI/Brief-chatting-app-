import 'package:chit_chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore fireStrore = FirebaseFirestore.instance;
  //
  static final _current_User = auth.currentUser;
  //
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
}
