import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/messageWidges/messageStatus.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/widgests/recordVoice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  DocumentSnapshot<Object>? doc;
  ChatScreen({super.key, this.doc});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  List<Message2> _list = [];
  List<String> image_list = [];
  Map<int, int> image_index = {};
  List<Message2> messages = [];
  int currentImageIndex = 0;

  Message2? message;
  int? index;
  // List<String> image_list;

  String getConversationID(String id) => api.user.uid.hashCode <= id.hashCode
      ? '${api.user.uid}_$id'
      : '${id}_${api.user.uid}';

  @override
  Widget build(BuildContext context) {
    final String userId = widget.doc?['id']; // Replace with the actual user ID
    final CollectionReference _usersCollection =
        FirebaseFirestore.instance.collection('users');

    final appController controller = Get.put(appController());
    final String toReceiverId = widget.doc!.id;
    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }

    print("The type of the doc in chat screen is ${widget.doc.runtimeType}");

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color.fromARGB(125, 32, 32, 32),
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
                  StreamBuilder<DocumentSnapshot>(
                    stream: _usersCollection.doc(userId).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      }
                      return Text(
                        snapshot.data!['is_online'] == true
                            ? "Online"
                            : "Offline",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(204, 255, 255, 255)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/chat_bg.jpg"),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(top: 103),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: api.getMessages(widget.doc!["id"]),
                        builder: (context, snapshot) {
                          var data = snapshot.data;
                          data != null
                              ? _list = data as List<Message2>
                              : _list = [];
                          return _list.isNotEmpty
                              ? ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  itemBuilder: (context, index) {
                                    if (_list[index].type == Type.image &&
                                        image_list.contains(_list[index].msg) ==
                                            false) {
                                      image_index[index] = currentImageIndex;
                                      currentImageIndex++;
                                      image_list.add(_list[index].msg);
                                    }
                                    // bool isMe = _list[index].fromId == api.user.uid;

                                    bool showDate = false;
                                    print("THe index is $index");
                                    print("THe list length is ${_list.length}");
                                    if (index != _list.length - 1 &&
                                        api.messageDate(
                                                _list[index + 1].sendingTime) !=
                                            api.messageDate(
                                                _list[index].sendingTime)) {
                                      showDate = true;
                                    }
                                    if (index == _list.length - 1) {
                                      showDate = true;
                                    }
                                    return showDate
                                        ? Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  // api.messageTime(
                                                  //     _list[index].sendingTime),
                                                  api.messageDate(
                                                      _list[index].sendingTime),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              messageStatus(
                                                message: _list[index],
                                                image_list: image_list,
                                                index: index,
                                                imageIndex: image_index,
                                              )
                                            ],
                                          )
                                        : messageStatus(
                                            message: _list[index],
                                            image_list: image_list,
                                            index: index,
                                            imageIndex: image_index,
                                          );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    "Say Hii 👋",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // width: 200,
                                  color: const Color.fromARGB(255, 65, 65, 65),
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 150),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          icon: const Icon(
                                              Icons.emoji_emotions_outlined,
                                              color: Color.fromARGB(
                                                  255, 218, 216, 216))),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: TextField(
                                            onChanged: (String value) {
                                              print("The value is $value");

                                              if (api.isOnlyWhiteSpaces(
                                                      value) ||
                                                  value.isEmpty) {
                                                controller
                                                    .changeRecordButton(false);
                                              }

                                              if (value.isNotEmpty &&
                                                  !api.isOnlyWhiteSpaces(
                                                      value)) {
                                                controller
                                                    .changeRecordButton(true);
                                              }

                                              msgController.text =
                                                  value.replaceFirst(
                                                      RegExp(r'^\s+'), '');
                                              print(
                                                  "The value is ${msgController.text}");
                                            },
                                            controller: msgController,
                                            enableSuggestions: true,
                                            maxLines: null,
                                            // expands: true,
                                            cursorColor: Colors.white,
                                            keyboardType:
                                                TextInputType.multiline,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: const InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                hoverColor: Colors.white,
                                                border: InputBorder.none,
                                                focusColor: Colors.white,
                                                fillColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        241, 255, 255, 255)),
                                                hintText: "Type a message"),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            // ImagePicker()
                                            //     .pickMultipleMedia()
                                            //     .then((value) {
                                            //   if (value != null &&
                                            //       value.isNotEmpty) {
                                            //     List<XFile> filteredMedia =
                                            //         value.where((file) {
                                            //       return file.path
                                            //               .toLowerCase()
                                            //               .endsWith('.jpg') ||
                                            //           file.path
                                            //               .toLowerCase()
                                            //               .endsWith('.jpeg') ||
                                            //           file.path
                                            //               .toLowerCase()
                                            //               .endsWith('.png') ||
                                            //           file.path
                                            //               .toLowerCase()
                                            //               .endsWith('.mp3') ||
                                            //           file.path
                                            //               .toLowerCase()
                                            //               .endsWith('.wav') ||
                                            //           file.path
                                            //               .toLowerCase()
                                            //               .endsWith('.aac');
                                            //     }).toList();
                                            //     for (var value
                                            //         in filteredMedia) {
                                            //       print("The value is $value");
                                            //       print(
                                            //           "The value path is ${value.path}");
                                            //       api.sendFile(
                                            //           widget.doc!["id"],
                                            //           File(value.path));
                                            //     }
                                            //   }
                                            // });
                                            try {
                                              await FilePicker.platform
                                                  .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png',
                                                  'mp3',
                                                  'wav',
                                                  'aac'
                                                ],
                                              ).then((value) {
                                                if (value != null) {
                                                  for (var file
                                                      in value.files) {
                                                    api.sendFile(
                                                        widget.doc!["id"],
                                                        File(file.path!));
                                                    print(
                                                        'Picked file: ${file.name}');
                                                  }
                                                } else {
                                                  // User canceled the picker
                                                }
                                              });
                                            } catch (e) {
                                              print("The error is $e");
                                            }
                                          },
                                          icon: const Icon(Icons.attach_file,
                                              color: Color.fromARGB(
                                                  255, 231, 231, 231))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 53, 49, 49),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  String checkSpaces =
                                      msgController.text.trim();
                                  if (checkSpaces.isEmpty ||
                                      checkSpaces == "") {
                                    return;
                                  }
                                  if (api
                                      .isOnlyWhiteSpaces(msgController.text)) {
                                    return;
                                  }
                                  controller.changeRecordButton(false);
                                  api.sendMessage(widget.doc?["id"],
                                      checkSpaces, Type.text);
                                  msgController.clear();
                                },
                                icon: const Icon(Icons.send,
                                    color: Color.fromARGB(255, 235, 235, 235))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Obx(() => !controller.getRecordButton
                ? recordAudio(toReceiverId)
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
