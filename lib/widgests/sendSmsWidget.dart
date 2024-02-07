// import 'dart:ffi';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/messageWidges/imageMessage.dart';
import 'package:chatapp/messageWidges/textMessage.dart';
import 'package:chatapp/messageWidges/uploadingFileWidget.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/pages/imageViewer.dart';
import 'package:chatapp/messageWidges/audioMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Widget sendSms(message, image_list, imageIndex, index, context) {
  bool showTime = false;
  if (api.sendPreviousDate != api.messageTime(message.sendingTime) ||
      message.read == false) {
    api.sendPreviousDate = api.messageTime(message.sendingTime);
    showTime = true;
  }
  bool onlyEmoji = api.containsOnlyEmojis(message.msg);
  print("The message is ${message.msg}");
  Widget widgetToShow;
  switch (message.type) {
    case Type.text:
      print("The message is working for text ");
      widgetToShow = textMessage(message: message, onlyEmoji: onlyEmoji);
      break;
    case Type.audio:
      print("The switch case is working");
      if (message.isSent == true) {
        widgetToShow = audioMessage(message: message, index: index);
      } else {
        widgetToShow = uploadingFileWidget(msg: message.msg);
      }
      break;
    case Type.image:
      if (message.isSent == true) {
        widgetToShow = imageMessage(
            message: message,
            image_list: image_list,
            imageIndex: imageIndex,
            index: index,
            context: context);
      } else {
        widgetToShow = uploadingFileWidget(msg: message.msg);
      }
      break;
    default:
      return SizedBox();
  }

  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widgetToShow,
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
