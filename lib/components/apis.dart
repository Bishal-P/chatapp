import 'dart:io';

import 'package:chatapp/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class api {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

//user id

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
}
