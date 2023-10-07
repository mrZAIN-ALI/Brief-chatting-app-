import 'package:chit_chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore fireStrore = FirebaseFirestore.instance;
  //
  static final _current_User = auth.currentUser;
  //
  static  late chatUUser_Info me_LoggedIn;
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
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAlusers(){
    return Apis.fireStrore.collection("users").snapshots();
  }
  //
  static Future<void> getLoggedInUserInfo() async {
    await fireStrore.collection("users").doc(_current_User!.uid).get().then((user) async{
      if(user.exists){
      me_LoggedIn = chatUUser_Info.mapJsonToModelObject(user.data()!);

      }else {
        await createUser().then((value) => getLoggedInUserInfo());
      }

    });
    // print("Data from firestore : ${data.data()}");
  }
  //
  static Future<void> updateUserInfo() async{
    await fireStrore.collection("users").doc(_current_User!.uid).update({
      "name": me_LoggedIn.name,
      "about": me_LoggedIn.about,
    });
  }
}
