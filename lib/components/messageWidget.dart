// // import 'dart:js';

// // import 'dart:ffi';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chatapp/components/apis.dart';
// import 'package:chatapp/models/messageModel.dart';
// import 'package:chatapp/newPages/message_model.dart';
// import 'package:chatapp/pages/imageViewer.dart';
// import 'package:chatapp/widgests/messageSubWidgets.dart';
// import 'package:chatapp/widgests/receiveSmsWidget.dart';
// import 'package:chatapp/widgests/sendSmsWidget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class messageInOut extends StatelessWidget {
//   final Message2 message;
//   int index;
//   List<String> image_list;
//   Map<int, int> imageIndex;
//   messageWidget(
//       {super.key,
//       required this.message,
//       required this.image_list,
//       required this.index,
//       required this.imageIndex});

//   @override
//   Widget build(BuildContext context) {
//     final bool isMe = message.fromId == api.user.uid;
//     // api.previousDate = "Today";

//     print("The read status of the mesage is ${message.read}");
//     // print("The message vale is ${api.messageTime(message.sentTime)}");

    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
//       child: receiverSms(message, image_list, imageIndex, index, context),
//       // child: !isMe
//       //     ? receiverSms(message, image_list, imageIndex, index, context)
//       //     : sendSms(message, image_list, imageIndex, index, context),
//       // child: Column(
//       //   crossAxisAlignment:
//       //       isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       //   children: [
//       // !isMe
//       //     ? receiverSms(message, image_list, imageIndex, index, context)
//       //     : sendSms(isMe, message, context),
//       // message.type == Type.text
//       //     ? smsWidget(isMe, message, context)
//       //     : message.isSent == false && message.fromId == api.user.uid
//       //         ? Container(
//       //             width: 200,
//       //             height: 70,
//       //             decoration: BoxDecoration(
//       //                 color: const Color.fromARGB(255, 44, 110, 253),
//       //                 borderRadius: BorderRadius.circular(10)),
//       //             child: Column(
//       //               crossAxisAlignment: CrossAxisAlignment.start,
//       //               children: [
//       //                 const Padding(
//       //                   padding: EdgeInsets.only(left: 10, top: 5),
//       //                   child: Text(
//       //                     "Sending File...",
//       //                     style: TextStyle(
//       //                         color: Colors.white54,
//       //                         fontSize: 12,
//       //                         fontWeight: FontWeight.bold),
//       //                   ),
//       //                 ),
//       //                 const Center(
//       //                   child: LinearProgressIndicator(
//       //                     color: Colors.lightBlueAccent,
//       //                   ),
//       //                 ),
//       //                 Expanded(
//       //                     child: Center(
//       //                         child: Text(
//       //                   "uploading...${message.msg} %",
//       //                   style: const TextStyle(
//       //                       color: Colors.white54,
//       //                       fontSize: 12,
//       //                       fontWeight: FontWeight.bold),
//       //                 )))
//       //               ],
//       //             ),
//       //           )
//       //         : message.isSent == true
//       //             ? InkWell(
//       //                 onTap: () {
//       //                   showCupertinoModalPopup(
//       //                       context: context,
//       //                       builder: (context) => image_viewer(
//       //                             imageList: image_list,
//       //                             index: imageIndex != {}
//       //                                 ? imageIndex[index]!
//       //                                 : 0,
//       //                           ));
//       //                   // image_list.add(message.msg);
//       //                   //  Navigator.push(context, MaterialPageRoute(builder: (context) => image_viewer(imageList: image_list,)));
//       //                   // Navigator.pushNamed(context
//       //                 },
//       //                 child: Container(
//       //                     constraints: BoxConstraints(
//       //                       maxWidth:
//       //                           MediaQuery.of(context).size.width * 0.8,
//       //                     ),
//       //                     padding: const EdgeInsets.symmetric(
//       //                         vertical: 5, horizontal: 5),
//       //                     decoration: BoxDecoration(
//       //                       color: isMe
//       //                           ? Color.fromARGB(255, 44, 110, 253)
//       //                           : Color.fromARGB(255, 227, 255, 101),
//       //                       borderRadius: BorderRadius.only(
//       //                         topLeft: const Radius.circular(15),
//       //                         topRight: const Radius.circular(15),
//       //                         bottomLeft: isMe
//       //                             ? const Radius.circular(15)
//       //                             : const Radius.circular(0),
//       //                         bottomRight: isMe
//       //                             ? const Radius.circular(0)
//       //                             : const Radius.circular(15),
//       //                       ),
//       //                     ),
//       //                     child: ClipRRect(
//       //                         borderRadius: BorderRadius.circular(20),
//       //                         child: CachedNetworkImage(
//       //                           filterQuality: FilterQuality.low,
//       //                           imageUrl: message.msg,
//       //                           placeholder: (context, url) => const Center(
//       //                               child: CircularProgressIndicator()),
//       //                           errorWidget: (context, url, error) =>
//       //                               const Icon(Icons.error),
//       //                           height: 200,
//       //                           width: 200,
//       //                           fit: BoxFit.cover,
//       //                         ))),
//       //               )
//       //             : SizedBox(),
//       // // message.isSent == true
//       // // ?
//       // Row(
//       //   mainAxisAlignment:
//       //       isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       //   children: [
//       //     Text(
//       //       // "12:00 PM",
//       //       api.messageTime(message.sendingTime),
//       //       style: const TextStyle(
//       //         color: Colors.grey,
//       //         fontSize: 12,
//       //       ),
//       //     ),
//       //     const SizedBox(width: 5),
//       //     isMe
//       //         ? Icon(
//       //             message.isSent ? Icons.done_all : Icons.done,
//       //             // Icons.done_all,
//       //             color: message.read == true ? Colors.blue : Colors.grey,
//       //             size: 20,
//       //           )
//       //         : const SizedBox(width: 0),
//       //   ],
//       // )
//       // // : SizedBox()
//       //   ],
//       // ),
//     );
//   }
// }

// // Widget messageWidget(String message, bool isMe) {
// //   return 
// // }
