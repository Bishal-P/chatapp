// import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/pages/imageViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget receiverSms(message, image_list, imageIndex, index, context) {
  // done(String id) async {
  //   await api.firestore
  //       .collection("users_chats")
  //       .doc(api.getConversationID(id))
  //       .collection("messages")
  //       .doc(message.sendingTime)
  //       .get()
  //       .then((value) {
  //     print("The value is => ${value.data()?["read"]}");
  //   });
  // }
  // Future<void> updateReadStatus(String id) async {
  // await api.firestore
  //     .collection("users_chats")
  //     .doc(api.getConversationID(id))
  //     .collection("messages")
  //     .doc(message.sendingTime)
  //     .update({
  //   "read": true,
  // });
  //     .doc(api.getConversationID(id))
  //     .collection("messages")
  //     .where("toId", isEqualTo: id)
  //     // .where("read", isEqualTo: false)
  //     .get()
  //     .then((value) {
  //   print("The value is => ${value.docs[0].data()["read"]}");
  //   value.docs.forEach((element) {
  //     print("The  => ${element.data()["read"]}");
  //     element.reference.update({
  //       "read": true,
  //     });
  //   });
  // });
  //   print("The read status is updated");
  // }

  message.read == false && message.isSent
      ? api.changeReadStatus(message)
      : null;

  // api.updateReadStatus(message);

  // print("The read status of the mesage is ${message.toId}");

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      message.type == Type.text
          ? Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.73,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 227, 255, 101),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: TextSelectionTheme(
                data: const TextSelectionThemeData(
                  // cursorColor: Colors.blue,
                  selectionColor: Color.fromARGB(255, 255, 175, 121),
                  selectionHandleColor: Colors.blue,
                ),
                child: SelectableText.rich(
                  TextSpan(
                    onExit: (event) => null,
                    text: message.msg,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          : message.isSent == true
              ? InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => image_viewer(
                              imageList: image_list,
                              index: imageIndex != null || imageIndex != {}
                                  ? imageIndex[index]
                                  : 0,
                            ));
                    // image_list.add(message.msg);
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => image_viewer(imageList: image_list,)));
                    // Navigator.pushNamed(context
                  },
                  child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 227, 255, 101),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.low,
                            imageUrl: message.msg,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ))),
                )
              : SizedBox(),

      // message.isSent == true
      // ?
      message.isSent == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  // "12:00 PM",
                  api.messageTime(message.sendingTime),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            )
          : SizedBox(),
    ],
  );
  // : SizedBox() ;
}
