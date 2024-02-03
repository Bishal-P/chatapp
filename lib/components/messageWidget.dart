// import 'dart:js';

import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/newPages/message_model.dart';
import 'package:chatapp/pages/imageViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class messageWidget extends StatelessWidget {
  final Message2 message;
  int index;
  List<String> image_list;
  Map<int, int> imageIndex;
  messageWidget(
      {super.key,
      required this.message,
      required this.image_list,
      required this.index,
      required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.fromId == api.user.uid;
    print("The message vale is ${api.messageTime(message.sent)}");

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          message.type == Type.text
              ? Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.73,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Color.fromARGB(255, 44, 110, 253)
                        : Color.fromARGB(255, 227, 255, 101),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: isMe
                          ? const Radius.circular(15)
                          : const Radius.circular(0),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(15),
                    ),
                  ),
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      // cursorColor: Colors.blue,
                      selectionColor: isMe
                          ? Color.fromARGB(255, 250, 167, 90)
                          : Color.fromARGB(255, 255, 175, 121),
                      selectionHandleColor: Colors.blue,
                    ),
                    child: SelectableText.rich(
                      TextSpan(
                        onExit: (event) => Void,
                        text: message.msg,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => image_viewer(
                              imageList: image_list,
                              index: imageIndex[index]!,
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
                      decoration: BoxDecoration(
                        color: isMe
                            ? Color.fromARGB(255, 44, 110, 253)
                            : Color.fromARGB(255, 227, 255, 101),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: isMe
                              ? const Radius.circular(15)
                              : const Radius.circular(0),
                          bottomRight: isMe
                              ? const Radius.circular(0)
                              : const Radius.circular(15),
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
                ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                api.messageTime(message.sent),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 5),
              isMe
                  ? Icon(
                      Icons.done_all,
                      color: isMe ? Colors.blue : Colors.grey,
                      size: 20,
                    )
                  : const SizedBox(width: 0),
            ],
          )
        ],
      ),
    );
  }
}

// Widget messageWidget(String message, bool isMe) {
//   return 
// }
