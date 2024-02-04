// import 'dart:ffi';

import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget smsWidget(bool isMe, Message2 message, BuildContext context) {
  // api.firestore.collection("messages").doc(message.).update({
  //   "isRead": true,
  // });
  // api.updateReadStatus(message.toId);
  Future<void> updateReadStatus(String id) async {
    await api.firestore
        .collection("users_chats")
        .doc(api.getConversationID(id))
        .collection("messages")
        .where("toId", isEqualTo: id)
        .where("read", isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.update({
          "read": true,
        });
      });
    });
    // await api.firestore
    //     .collection("users_chats")
    //     .doc(api.getConversationID(id))
    //     .collection("messages")
    //     .where("toId", isEqualTo: api.user.uid)
    //     .where("read", isEqualTo: "false")
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((element) {
    //     element.reference.update({
    //       "read": "true",
    //     });
    //   });
    // });
    // // print("The read status is updated");
  }

  if (message.read == false && message.fromId != api.user.uid) {
    updateReadStatus(message.toId);
  }
  return Container(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.73,
    ),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    decoration: BoxDecoration(
      color: isMe
          ? const Color.fromARGB(255, 44, 110, 253)
          : const Color.fromARGB(255, 227, 255, 101),
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(15),
        topRight: const Radius.circular(15),
        bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
        bottomRight:
            isMe ? const Radius.circular(0) : const Radius.circular(15),
      ),
    ),
    child: TextSelectionTheme(
      data: TextSelectionThemeData(
        // cursorColor: Colors.blue,
        selectionColor: isMe
            ? const Color.fromARGB(255, 250, 167, 90)
            : const Color.fromARGB(255, 255, 175, 121),
        selectionHandleColor: Colors.blue,
      ),
      child: SelectableText.rich(
        TextSpan(
          onExit: (event) => null,
          text: message.msg,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
