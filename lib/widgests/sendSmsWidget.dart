// import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/pages/imageViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget sendSms(message, image_list, imageIndex, index, context) {
  bool showTime = false;
  if (api.sendPreviousDate != api.messageTime(message.sendingTime) ||
      message.read == false) {
    api.sendPreviousDate = api.messageTime(message.sendingTime);
    showTime = true;
  }
  bool onlyEmoji = api.containsOnlyEmojis(message.msg);
  return InkWell(
    onLongPress: () {},
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        message.type == Type.text
            ? Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.73,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: onlyEmoji
                      ? Colors.transparent
                      :const Color.fromARGB(255, 44, 110, 253),
                  borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: TextSelectionTheme(
                  data: const TextSelectionThemeData(
                    // cursorColor: Colors.blue,
                    selectionColor: Color.fromARGB(255, 73, 73, 73),
                    selectionHandleColor: Colors.blue,
                  ),
                  child: SelectableText.rich(
                    TextSpan(
                      onExit: (event) => null,
                      text: message.msg,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: onlyEmoji ? 29 : 16,
                      ),
                    ),
                  ),
                ),
              )
            : message.isSent == false
                ? Container(
                    width: 200,
                    height: 70,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 44, 110, 253),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            "Sending File...",
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Center(
                          child: LinearProgressIndicator(
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          "uploading...${message.msg} %",
                          style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        )))
                      ],
                    ),
                  )
                : message.isSent == true
                    ? InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => image_viewer(
                                    imageList: image_list,
                                    index: imageIndex != {}
                                        ? imageIndex[index]!
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
                              color: Color.fromARGB(255, 44, 110, 253),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(0)),
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
        showTime
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  Icon(
                    message.isSent ? Icons.done_all : Icons.done,
                    // Icons.done_all,
                    color: message.read == true ? Colors.blue : Colors.grey,
                    size: 20,
                  )
                ],
              )
            : SizedBox(),
        // : SizedBox()
      ],
    ),
  );
}
