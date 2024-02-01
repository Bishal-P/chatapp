import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
// import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/messageWidget.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_animate/flutter_animate.dart';

class ChatScreen extends StatefulWidget {
  DocumentSnapshot<Object>? doc;
  ChatScreen({super.key, this.doc});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  List<Message> _list = [];
  List<String> image_list = [];
  List<Message> messages = [];
  List msg = [
    "Hii",
    "hello",
    "how are you ?",
    "I am fine",
    "what about you ?dfgdgasfsdfjkahsdfjhasjdfhjashdfjafmbasjdfhjash sdgsdfgadfg hello how are you ?",
    "I am also fine",
    "ok",
    "bye",
    "Hii",
    "hello",
    "how are you ?",
    "I am fine",
    "what about you ?",
    "I am also fine",
    "ok",
    "bye",
  ];

  List isMe = [
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
  ];

  String getConversationID(String id) => api.user.uid.hashCode <= id.hashCode
      ? '${api.user.uid}_$id'
      : '${id}_${api.user.uid}';

  @override
  Widget build(BuildContext context) {
    print("The doc id is ${widget.doc!}");
    print("the conver id is : ${getConversationID(widget.doc!.id)}");
    print("The hashcode is ${api.user.uid.hashCode}");

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: widget.doc!['image'],
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.doc!['name'].toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                        Text(widget.doc!['is_online'].toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.only(top: 11),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: api.getMessages(widget.doc!["id"]),
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      data != null ? _list = data as List<Message> : _list = [];
                      // _list = snapshot.data as List<Message>;
                      // print("The list is $_list");
                      // print("THe first values is: ${_list[0].msg}");
                      return _list.isNotEmpty
                          ? ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                if (_list[index].type == Type.image &&
                                    image_list.contains(_list[index].msg) ==
                                        false) {
                                  image_list.add(_list[index].msg);
                                }
                                return messageWidget(
                                  message: _list[index],
                                  image_list: image_list,
                                  index: index,
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "Say Hii 👋",
                                style: TextStyle(fontSize: 25),
                              ),
                            );
                    },
                  ),
                ),
                Container(
                  // height: 52,
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions_outlined,
                                color: Colors.black)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: msgController,
                              enableSuggestions: true,
                              maxLines: null,
                              // expands: true,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message"),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              ImagePicker().pickMedia().then((value) {
                                if (value != null) {
                                  api.sendImage(
                                      widget.doc!["id"], File(value!.path));
                                }
                              });
                            },
                            icon: const Icon(Icons.attach_file,
                                color: Colors.black)),
                        IconButton(
                            onPressed: () {
                              api.sendMessage(widget.doc?["id"],
                                  msgController.text, Type.text);
                              msgController.clear();
                              print("The message is ${msgController.text}");
                              print(
                                  "the getmessages are :${api.getMessages(widget.doc!["id"])}");
                            },
                            icon: const Icon(Icons.send, color: Colors.black)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
