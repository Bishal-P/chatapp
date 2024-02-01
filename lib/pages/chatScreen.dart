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
          title: Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              widget.doc?["image"] != ""
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          CachedNetworkImageProvider(widget.doc!["image"]),
                    )
                  : CircleAvatar(
                      radius: 25,
                      child: Text(widget.doc!["name"][0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.black))),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doc!["name"],
                    style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.doc!["is_online"] == true ? "Online" : "Offline",
                    style:const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(204, 255, 255, 255)),
                  ),
                ],
              ),
            ],
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
                              onChanged: (String value) {
                                msgController.text =
                                    value.replaceFirst(RegExp(r'^\s+'), '');
                                print("The value is ${msgController.text}");
                              },
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
                              String checkSpaces = msgController.text.trim();
                              if (checkSpaces.isEmpty || checkSpaces == "") {
                                return;
                              }
                              api.sendMessage(
                                  widget.doc?["id"], checkSpaces, Type.text);
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
