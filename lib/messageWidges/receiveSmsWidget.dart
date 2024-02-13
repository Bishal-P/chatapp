
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/messageWidges/audioMessage.dart';
import 'package:chatapp/messageWidges/imageMessage.dart';
import 'package:chatapp/messageWidges/textMessage.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';


Widget receiverSms(message, image_list, imageIndex, index, context) {
  bool showTime = false;
  if (api.sendPreviousDate != api.messageTime(message.sendingTime) ||
      message.read == false) {
    api.sendPreviousDate = api.messageTime(message.sendingTime);
    showTime = true;
  }
  message.read == false && message.isSent
      ? api.changeReadStatus(message)
      : null;
  bool onlyEmoji = api.containsOnlyEmojis(message.msg);

  Widget widgetToShow;
  switch (message.type) {
    case Type.text:
      widgetToShow = textMessage(message: message, onlyEmoji: onlyEmoji);
      break;
    case Type.audio:
      if (message.isSent == true) {
        widgetToShow = audioMessage(message: message, index: index);
      } else {
        // widgetToShow = uploadingFileWidget(msg: message.msg);
        widgetToShow = const SizedBox();
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
        // widgetToShow = uploadingFileWidget(msg: message.msg);
        widgetToShow = const SizedBox();
      }
      break;
    default:
      return SizedBox();
  }

  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widgetToShow,
        showTime && message.isSent
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
                 
                ],
              )
            :const SizedBox(),
        // : SizedBox()
      ],
    ),
  );
}
