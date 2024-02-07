// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chatapp/components/apis.dart';
// import 'package:chatapp/components/appController.dart';
// import 'package:chatapp/components/messa.dart';
// // import 'package:chatapp/components/apis.dart';
// // import '../../assets/messa.dart';
// import 'package:chatapp/models/messageModel.dart';
// import 'package:chatapp/widgests/audioMessage.dart';
// import 'package:chatapp/widgests/testVoice.dart';
// // import 'package:chatapp/pages/imageViewer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:social_media_recorder/audio_encoder_type.dart';
// import 'package:social_media_recorder/screen/social_media_recorder.dart';
// // import 'package:flutter_animate/flutter_animate.dart';

// class ChatScreen extends StatefulWidget {
//   DocumentSnapshot<Object>? doc;
//   ChatScreen({super.key, this.doc});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController msgController = TextEditingController();
//   List<Message2> _list = [];
//   List<String> image_list = [];
//   Map<int, int> image_index = {};
//   List<Message2> messages = [];
//   int currentImageIndex = 0;

//   Message2? message;
//   int? index;
//   // List<String> image_list;

//   String getConversationID(String id) => api.user.uid.hashCode <= id.hashCode
//       ? '${api.user.uid}_$id'
//       : '${id}_${api.user.uid}';

//   @override
//   Widget build(BuildContext context) {
//     final String userId = widget.doc?['id']; // Replace with the actual user ID
//     final CollectionReference _usersCollection =
//         FirebaseFirestore.instance.collection('users');

//     // final ScrollController _scrollController = ScrollController();

//     // print("The doc reference is ${_documentReference}");

//     final appController controller = Get.put(appController());
//     print("The doc id is ${widget.doc!.id}");
//     print("the conver id is : ${getConversationID(widget.doc!.id)}");
//     print("The hashcode is ${api.user.uid.hashCode}");

//     //print the last message value from the getLastMessage method
//     print("The last message is ${api.getLastMessage(widget.doc!["id"])}");

//     print("The last message is ${api.getLastMessage(widget.doc!["id"])}");
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           toolbarHeight: 70,
//           backgroundColor: const Color.fromARGB(125, 32, 32, 32),
//           automaticallyImplyLeading: false,
//           title: Row(
//             children: [
//               IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.white,
//                   )),
//               widget.doc?["image"] != ""
//                   ? CircleAvatar(
//                       radius: 25,
//                       backgroundImage:
//                           CachedNetworkImageProvider(widget.doc!["image"]),
//                     )
//                   : CircleAvatar(
//                       radius: 25,
//                       child: Text(widget.doc!["name"][0].toUpperCase(),
//                           style: const TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black))),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.doc!["name"],
//                     style: const TextStyle(
//                         fontSize: 23,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white),
//                   ),
//                   const SizedBox(height: 3),
//                   StreamBuilder<DocumentSnapshot>(
//                     stream: _usersCollection.doc(userId).snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return Text('Loading...');
//                       }
//                       return Text(
//                         snapshot.data!['is_online'] == true
//                             ? "Online"
//                             : "Offline",
//                         style: const TextStyle(
//                             fontSize: 15,
//                             color: Color.fromARGB(204, 255, 255, 255)),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           decoration: const BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage("assets/chat_bg.jpg"), fit: BoxFit.cover),
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30), topRight: Radius.circular(30))),
//           child: Padding(
//             padding: const EdgeInsets.only(top: 103),
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 60),
//                     child: Expanded(
//                       child: StreamBuilder(
//                         stream: api.getMessages(widget.doc!["id"]),
//                         builder: (context, snapshot) {
//                           var data = snapshot.data;
//                           data != null
//                               ? _list = data as List<Message2>
//                               : _list = [];
//                           return _list.isNotEmpty
//                               ? ListView.builder(
//                                   reverse: true,
//                                   itemCount: _list.length,
//                                   itemBuilder: (context, index) {
//                                     if (_list[index].type == Type.image &&
//                                         image_list.contains(_list[index].msg) ==
//                                             false) {
//                                       image_index[index] = currentImageIndex;
//                                       currentImageIndex++;
//                                       image_list.add(_list[index].msg);
//                                     }
//                                     // bool isMe = _list[index].fromId == api.user.uid;

//                                     bool showDate = false;
//                                     print("THe index is $index");
//                                     print("THe list length is ${_list.length}");
//                                     if (index != _list.length - 1 &&
//                                         api.messageDate(
//                                                 _list[index + 1].sendingTime) !=
//                                             api.messageDate(
//                                                 _list[index].sendingTime)) {
//                                       showDate = true;
//                                     }
//                                     if (index == _list.length - 1) {
//                                       showDate = true;
//                                     }
//                                     return audioMessage();
//                                     // return showDate
//                                     //     ? Column(
//                                     //         children: [
//                                     //           Container(
//                                     //             margin: const EdgeInsets.only(
//                                     //                 bottom: 10),
//                                     //             padding:
//                                     //                 const EdgeInsets.symmetric(
//                                     //                     vertical: 5,
//                                     //                     horizontal: 10),
//                                     //             decoration: BoxDecoration(
//                                     //               color: Colors.grey[300],
//                                     //               borderRadius:
//                                     //                   BorderRadius.circular(10),
//                                     //             ),
//                                     //             child: Text(
//                                     //               // api.messageTime(
//                                     //               //     _list[index].sendingTime),
//                                     //               api.messageDate(
//                                     //                   _list[index].sendingTime),
//                                     //               style: const TextStyle(
//                                     //                 color: Colors.black,
//                                     //                 fontSize: 12,
//                                     //               ),
//                                     //             ),
//                                     //           ),
//                                     //           // Text(
//                                     //           // api.messageDate(
//                                     //           //     _list[index].sendingTime),
//                                     //           //   style: const TextStyle(
//                                     //           //       color: Colors.white),
//                                     //           // ),
//                                     //           messa(
//                                     //             message: _list[index],
//                                     //             image_list: image_list,
//                                     //             index: index,
//                                     //             imageIndex: image_index,
//                                     //           ),
//                                     //         ],
//                                     //       )
//                                     //     : messa(
//                                     //         message: _list[index],
//                                     //         image_list: image_list,
//                                     //         index: index,
//                                     //         imageIndex: image_index,
//                                     //       );
//                                   },
//                                 )
//                               : const Center(
//                                   child: Text(
//                                     "Say Hii 👋",
//                                     style: TextStyle(
//                                         fontSize: 25, color: Colors.white),
//                                   ),
//                                 );
//                         },
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 5),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 // width: 200,
//                                 color: const Color.fromARGB(255, 65, 65, 65),
//                               ),
//                               child: ConstrainedBox(
//                                 constraints: BoxConstraints(maxHeight: 150),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                             Icons.emoji_emotions_outlined,
//                                             color: Color.fromARGB(
//                                                 255, 218, 216, 216))),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: TextField(
//                                           onChanged: (String value) {
// print("The value is $value");
// if (value.isEmpty ||
//     controller.recordButton.value ==
//         false) {
//   controller.changeRecordButton();
// }
//                                             msgController.text =
//                                                 value.replaceFirst(
//                                                     RegExp(r'^\s+'), '');
//                                             print(
//                                                 "The value is ${msgController.text}");
//                                           },
//                                           controller: msgController,
//                                           enableSuggestions: true,
//                                           maxLines: null,
//                                           // expands: true,
//                                           cursorColor: Colors.white,
//                                           keyboardType: TextInputType.multiline,
//                                           style: const TextStyle(
//                                               color: Colors.white),
//                                           decoration: const InputDecoration(
//                                               labelStyle: TextStyle(
//                                                   color: Colors.white),
//                                               hoverColor: Colors.white,
//                                               border: InputBorder.none,
//                                               focusColor: Colors.white,
//                                               fillColor: Colors.white,
//                                               hintStyle: TextStyle(
//                                                   color: Color.fromARGB(
//                                                       241, 255, 255, 255)),
//                                               hintText: "Type a message"),
//                                         ),
//                                       ),
//                                     ),
//                                     IconButton(
//                                         onPressed: () {
//                                           ImagePicker()
//                                               .pickMedia()
//                                               .then((value) {
//                                             if (value != null) {
//                                               api.sendFile(widget.doc!["id"],
//                                                   File(value!.path));
//                                             }
//                                           });
//                                         },
//                                         icon: const Icon(Icons.attach_file,
//                                             color: Color.fromARGB(
//                                                 255, 231, 231, 231))),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                                 color: controller.getRecordButton == true
//                                     ? Color.fromARGB(255, 53, 49, 49)
//                                     : Colors.greenAccent,
//                                 borderRadius: BorderRadius.circular(25)),
//                             child: controller.recordButton.value
//                                 ? const Icon(
//                                     Icons.send,
//                                     color: Colors.white,
//                                   )
//                                 : const Icon(
//                                     Icons.mic,
//                                     color: Colors.white,
//                                   )
//                             // child: IconButton(
//                             //     color: Colors.white,
//                             //     onPressed: () {
//                             // String checkSpaces = msgController.text.trim();
//                             // if (checkSpaces.isEmpty || checkSpaces == "") {
//                             //   return;
//                             // }
//                             // api.sendMessage(
//                             //     widget.doc?["id"], checkSpaces, Type.text);
//                             // msgController.clear();
//                             // print("The message is ${msgController.text}");
//                             // print(
//                             // "the getmessages are :${api.getMessages(widget.doc!["id"])}");
//                             //     },
//                             //     icon: const Icon(Icons.send,
//                             //         color: Color.fromARGB(255, 235, 235, 235))),
//                             ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/components/audioplayerControls.dart';
import 'package:chatapp/messageWidges/messageStatus.dart';
// import 'package:chatapp/components/messageInOut.dart';
// import 'package:chatapp/components/apis.dart';
// import '../../assets/messa.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/widgests/recordVoice.dart';
// import 'package:chatapp/pages/imageViewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class AudioPlayerController extends GetxController {
//   late final AudioPlayer audioPlayer;
//   bool isPlaying = false;
//   var currentPosition = Duration(seconds: 0)
//       .obs; // Observable variable for current playback position

//   late Timer _timer;

//   var duration=0.obs;

//   get getDuration => duration.value;
//   set setDuration(value) => duration.value = value;

//   var totalDuration = Duration(seconds: 120).obs;
//   get getTotalDuration => totalDuration.value;

//   @override
//   void onInit() {
//     super.onInit();
//     audioPlayer = AudioPlayer();
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       // if (isPlaying) {
//       // If audio is playing, update currentPosition
//       currentPosition.value += Duration(seconds: 1);
//       // setDuration = currentPosition.value;
//       // }
//     });
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   void play(String url) async {
//     if (isPlaying) {
//       await audioPlayer.stop();
//       isPlaying = false;
//     }
//     audioPlayer.stop();
//     await audioPlayer.play(DeviceFileSource(url));
//     // setDuration = audioPlayer.getDuration() as Duration;
//     // setTotalDuration = audioPlayer.getDuration();
//     isPlaying = true;
//   }

//   void pause() async {
//     if (isPlaying) {
//       await audioPlayer.pause();
//       isPlaying = false;
//     }
//     await audioPlayer.pause();
//   }

//   void stop() async {
//     if (isPlaying) {
//       await audioPlayer.stop();
//       isPlaying = false;
//     }
//     await audioPlayer.stop();
//   }

//   void seek(double value) {
//     audioPlayer.seek(Duration(milliseconds: value.toInt()));
//     currentPosition.value = Duration(milliseconds: value.toInt());
//     // setDuration = Duration(milliseconds: value.toInt());
//   }
// }

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
    // final ScrollController _scrollController = ScrollController();
    // final AudioPlayer audioPlayer = AudioPlayer();

    // print("The doc reference is ${_documentReference}");

    final appController controller = Get.put(appController());
    final String toReceiverId = widget.doc!.id;
    print("The doc id is ${widget.doc!.id}");
    print("the conver id is : ${getConversationID(widget.doc!.id)}");
    print("The hashcode is ${api.user.uid.hashCode}");

    //print the last message value from the getLastMessage method
    print("The last message is ${api.getLastMessage(widget.doc!["id"])}");

    print("The last message is ${api.getLastMessage(widget.doc!["id"])}");
    // final AudioPlayerController audioPlayerController =
    //     Get.put(AudioPlayerController());

    // api.saveFileToCustomFolder(
    //     "new", "newfile.cpp", File("/home/bishal/Desktop/test.cpp"));
    // File fileToSave = File('/home/bishal/Desktop/test.cpp');
    // api.checkAndCreateDirectory("Naincy");

    @override
    void dispose() {
      // audioPlayerController.audioPlayer.dispose();
      super.dispose();
    }

    return PopScope(
      onPopInvoked: (didPop) {
        // audioControls.audioPlayer.stop();
        // audioPlayerController.audioPlayer.stop();
      },
      child: GestureDetector(
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
                                          image_list
                                                  .contains(_list[index].msg) ==
                                              false) {
                                        image_index[index] = currentImageIndex;
                                        currentImageIndex++;
                                        image_list.add(_list[index].msg);
                                      }
                                      // bool isMe = _list[index].fromId == api.user.uid;

                                      bool showDate = false;
                                      print("THe index is $index");
                                      print(
                                          "THe list length is ${_list.length}");
                                      if (index != _list.length - 1 &&
                                          api.messageDate(_list[index + 1]
                                                  .sendingTime) !=
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    // api.messageTime(
                                                    //     _list[index].sendingTime),
                                                    api.messageDate(_list[index]
                                                        .sendingTime),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                // Text(
                                                // api.messageDate(
                                                //     _list[index].sendingTime),
                                                //   style: const TextStyle(
                                                //       color: Colors.white),
                                                // ),
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
                                    color:
                                        const Color.fromARGB(255, 65, 65, 65),
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 150),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
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
                                                  controller.changeRecordButton(
                                                      false);
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
                                            onPressed: () {
                                              ImagePicker()
                                                  .pickMedia()
                                                  .then((value) {
                                                if (value != null) {
                                                  api.sendFile(
                                                      widget.doc!["id"],
                                                      File(value.path));
                                                }
                                              });
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
                                  color: Color.fromARGB(255, 53, 49, 49),
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
                                    if (api.isOnlyWhiteSpaces(
                                        msgController.text)) {
                                      return;
                                    }
                                    controller.changeRecordButton(false);
                                    api.sendMessage(widget.doc?["id"],
                                        checkSpaces, Type.text);
                                    msgController.clear();

                                    print(
                                        "The message is ${msgController.text}");
                                    print(
                                        "the getmessages are :${api.getMessages(widget.doc!["id"])}");
                                  },
                                  icon: const Icon(Icons.send,
                                      color:
                                          Color.fromARGB(255, 235, 235, 235))),
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
                  : SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
