import 'dart:io';

import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class api {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    final Message message = Message(
      toId: receiverId,
      msg: text,
      read: "false",
      type: type,
      fromId: api.user.uid,
      sent: DateTime.now().toString(),
    );
    await firestore
        .collection("users_chats")
        .doc(getConversationID(message.toId))
        .collection("messages")
        .doc(getTime())
        .set(message.toJson());
  }


// send image
  static sendImage(String receiverId, File file) async {
    final extension = file.path.split('.').last;
    final Reference ref = storage
        .ref()
        .child("messages/${getConversationID(receiverId)}/${getTime()}.$extension");
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$extension"))
        .whenComplete(() async {
      final url = await ref.getDownloadURL();
      final Message message = Message(
        toId: receiverId,
        msg: url,
        read: "false",
        type: Type.image,
        fromId: api.user.uid,
        sent: DateTime.now().toString(),
      );
      await firestore
          .collection("users_chats")
          .doc(getConversationID(message.toId))
          .collection("messages")
          .doc(getTime())
          .set(message.toJson());
    });
  }

// getting messages
  static Stream<List<Message>> getMessages(String id) {
    return firestore
        .collection("users_chats")
        .doc(getConversationID(id))
        .collection("messages")
        .orderBy("sent", descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromJson(e.data())).toList());
  }
}
