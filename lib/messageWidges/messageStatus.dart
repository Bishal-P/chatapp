import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/widgests/receiveSmsWidget.dart';
import 'package:chatapp/widgests/sendSmsWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class messageStatus extends StatelessWidget {
  final Message2 message;
  int index;
  List<String> image_list;
  Map<int, int> imageIndex;
   messageStatus({super.key , required this.message, required this.image_list, required this.index, required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.fromId == api.user.uid;
    return isMe ? sendSms(message, image_list, imageIndex, index, context) : receiverSms(message, image_list, imageIndex, index, context);
  }
}