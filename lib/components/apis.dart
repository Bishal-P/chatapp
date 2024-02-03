import 'dart:io';

import 'package:chatapp/components/appController.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

class api {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // static appController controller = Get.put(appController());

  ////updating the message previous date
  static String previousDate = "";

//user id
// api.user
  //using later this to change the files
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User user = auth.currentUser!;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //checking userExist or not
  static Future<bool> userExist() async {
    bool result =
        (await firestore.collection("users").doc(user.uid).get()).exists;
    return result;
  }

// update user profile picture
  static Future<bool> updateProfilePicture(File file) async {
    final extension = file.path.split('.').last;
    final Reference ref =
        storage.ref().child("profile_pictures/${user.uid}.$extension");
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$extension"))
        .whenComplete(() async {
      final url = await ref.getDownloadURL();
      await firestore.collection("users").doc(user.uid).update({
        "image": url,
      });
    });
    return true;
  }

  //create user
  static Future<void> createUser() async {
    final ChatUser chatUser = ChatUser(
      image: user.photoURL ?? "",
      name: user.displayName ?? "NewUser",
      about: "Hey there! I am using ChatApp",
      createdAt: DateTime.now().toString(),
      lastActive: DateTime.now().toString(),
      id: user.uid,
      isOnline: false,
      pushToken: "",
      email: user.email ?? "",
    );
    await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson())
        .then((value) => print("User Created successfully"));
  }

// creating a unique conversation id
  static String getConversationID(String id) =>
      api.user.uid.hashCode <= id.hashCode
          ? '${api.user.uid}_$id'
          : '${id}_${api.user.uid}';

// get time as message id
  static String getTime() => DateTime.now().millisecondsSinceEpoch.toString();

// sending message
  static sendMessage(String receiverId, String text, Type type) async {
    final Message2 message = Message2(
      toId: receiverId,
      msg: text,
      read: "false",
      type: type,
      fromId: api.user.uid,
      sentTime: DateTime.now().toString(),
      isSent: true,
      sendingTime: DateTime.now().toString(),
    );
    await firestore
        .collection("users_chats")
        .doc(getConversationID(message.toId))
        .collection("messages")
        .doc(getTime())
        .set(message.toJson());
    print("The message is sent");
  }

// send image
  static sendImage(String receiverId, File file) async {
    // controller.setUploading(true);
    final String docId = getTime();
    final Message2 message = Message2(
      toId: receiverId,
      msg: "0",
      read: "false",
      type: Type.image,
      fromId: api.user.uid,
      sendingTime: DateTime.now().toString(),
      sentTime: "",
      isSent: false,
    );
    firestore
        .collection("users_chats")
        .doc(getConversationID(message.toId))
        .collection("messages")
        .doc(docId)
        .set(message.toJson());
    print("The image message is sent");
    UploadTask? uploadTask;
    final extension = file.path.split('.').last;
    final Reference ref = storage.ref().child(
        "messages/${getConversationID(receiverId)}/${getTime()}.$extension");
    uploadTask =
        ref.putFile(file, SettableMetadata(contentType: "image/$extension"));
    uploadTask.snapshotEvents.listen(
      (TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload is $progress% done');
        firestore
            .collection("users_chats")
            .doc(getConversationID(receiverId))
            .collection("messages")
            .doc(docId)
            .update({
          "msg": progress.toInt().toString(),
        });
        // appController().setUploadProgress(progress.toInt());
      },
      onError: (Object error) {
        print('Error: $error');
      },
      onDone: () {
        print('Upload Complete');
        // Close the stream when done
      },
      cancelOnError: true,
    );
    uploadTask.whenComplete(() async {
      print('Upload Complete (onCompletion)');
      final url = await ref.getDownloadURL();
      firestore
          .collection("users_chats")
          .doc(getConversationID(receiverId))
          .collection("messages")
          .doc(docId)
          .update({
        "msg": url,
        "isSent": true,
        "sentTime": DateTime.now().toString()
      }).then((value) {
        // controller.setUploading(false);
        // controller.uploadProgress(0);
      });
    });
  }

// getting messages
  static Stream<List<Message2>> getMessages(String id) {
    return firestore
        .collection("users_chats")
        .doc(getConversationID(id))
        .collection("messages")
        .orderBy("sendingTime", descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message2.fromJson(e.data())).toList());
  }

// to conver time from milliseconds to 12:00 AM/PM
  static String messageTime(String time) {
    final DateTime dateTime = DateTime.parse(time);
    final String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  // to get the date from milliseconds to date format
  static String messageDate(String time) {
    final DateTime todayDate = DateTime.now();
    final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    final DateTime date = DateTime.parse(time);
    String formattedDate = DateFormat('dd:MM:yy').format(date);
    if (formattedDate == DateFormat('dd:MM:yy').format(todayDate)) {
      return "Today";
    } else if (yesterday == formattedDate) {
      return "Yesterday";
    }
    return formattedDate;
  }
}
