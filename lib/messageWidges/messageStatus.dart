import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/messageWidges/receiveSmsWidget.dart';
import 'package:chatapp/messageWidges/sendSmsWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class messageStatus extends StatelessWidget {
  final Message2 message;
  final int index;
  final List<String> image_list;
  final Map<int, int> imageIndex;
  const messageStatus(
      {super.key,
      required this.message,
      required this.image_list,
      required this.index,
      required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.fromId == api.user.uid;
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: isMe
            ? sendSms(message, image_list, imageIndex, index, context)
            : receiverSms(message, image_list, imageIndex, index, context));
  }
}
