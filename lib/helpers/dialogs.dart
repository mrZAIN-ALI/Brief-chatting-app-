import 'package:chit_chat/api/api.dart';
import 'package:chit_chat/models/message.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  //
  static void showSnackBar_error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onError, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSnackBar_Normal(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onError, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgressIndicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static void showEditMessagDialog(BuildContext context, Messages currentMsg) {
    String UpdatedMessage = currentMsg.msg;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(
                width: 10,
              ),
              Text("Edit Message"),
            ],
          ),
          content: TextFormField(
            initialValue: UpdatedMessage,
            onChanged: (value) {
              UpdatedMessage = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Apis.UpdateMessage(currentMsg, UpdatedMessage);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  //Show Add new user Dialog
  static void showAddNewFriendDialog(BuildContext context) {
    String newFriendEmail = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.person_add_alt),
              SizedBox(
                width: 10,
              ),
              Text(
                "Add Friend",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: TextFormField(
            onChanged: (value) {
              newFriendEmail = value;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email_outlined,
              ),
              hintText: "Joe@gmail.com",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (newFriendEmail != "")
                  await Apis.addNewFriend(newFriendEmail).then(
                    (value) => {
                      if (!value)
                        {
                          DialogHelper.showSnackBar_error(context,
                              "This Email is not registered to Chit Chat")
                        }
                    },
                  );
                Navigator.pop(context);
              },
              child: Text("Add Friend"),
            ),
          ],
        );
      },
    );
  }
}
