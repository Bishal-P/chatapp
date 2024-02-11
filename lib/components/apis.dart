import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class api {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // static appController controller = Get.put(appController());

  ////updating the message previous date
  static String sendPreviousDate = "";
  static String receivePreviousDate = "";

//user id
// api.user
  //using later this to change the files
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User user = auth.currentUser!;
  static FirebaseStorage storage = FirebaseStorage.instance;

  // /audioplayer instance
  static AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> playAudio(
      String sendingTime, String urlName, String folderName) async {
    // bool yes= checkFileExists(sendingTime, urlName, folderName);
    bool yesExists = await checkFileExists(sendingTime, urlName, folderName);
    if (!yesExists) {
      await downloadAndSaveFile(urlName, folderName, sendingTime);
    }
    DeviceFileSource fileSource = DeviceFileSource(
        "/storage/emulated/0/Android/data/com.example.chatapp/files/$folderName/${createFileName(sendingTime, urlName)}");
    await audioPlayer.play(fileSource);
  }

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
    final String time = getTime();
    final Message2 message = Message2(
      toId: receiverId,
      msg: text,
      read: false,
      type: type,
      fromId: api.user.uid,
      sentTime: time,
      isSent: true,
      sendingTime: time,
    );
    await firestore
        .collection("users_chats")
        .doc(getConversationID(message.toId))
        .collection("messages")
        .doc(time)
        .set(message.toJson());
    print("The message is sent");
  }

  static Future<void> updateReadStatus(Message2 message) async {
    await api.firestore
        .collection("users_chats")
        .doc(api.getConversationID(message.toId))
        .collection("messages")
        .doc(message.sendingTime)
        .update({
      "read": true,
    });
  }

// send image
  static Type getFileType(String fileName) {
    // Get the file extension
    String fileExtension = fileName.split('.').last.toLowerCase();

    // Map file extensions to file types
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Type.image;
      // case 'mp4':
      // case 'mov':
      // case 'avi':
      //   return Type.video;
      case 'mp3':
      case 'wav':
      case 'ogg':
      case 'm4a':
        return Type.audio;
      default:
        return Type.unknown;
    }
  }

  static sendFile(String receiverId, File file) async {
    // controller.setUploading(true);

    final String docId = getTime();
    final Message2 message = Message2(
      toId: receiverId,
      msg: "0",
      read: false,
      type: getFileType(file.path.split('/').last),
      fromId: api.user.uid,
      sendingTime: DateTime.now().millisecondsSinceEpoch.toString(),
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
        "sentTime": DateTime.now().millisecondsSinceEpoch.toString(),
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
    final intTime = int.parse(time);
    String time2 = DateTime.fromMillisecondsSinceEpoch(intTime).toString();
    final DateTime dateTime = DateTime.parse(time2);
    final String formattedTime =
        DateFormat('hh:mm a').format(dateTime).toString();
    return formattedTime;
  }

  // to get the date from milliseconds to date format
  static String messageDate(String time) {
    final DateTime todayDate = DateTime.now();
    int time2 = int.parse(time);
    
    if (todayDate.day == DateTime.fromMillisecondsSinceEpoch(time2).day) {
      return "Today";
    }
    if (todayDate.day - 1 == DateTime.fromMillisecondsSinceEpoch(time2).day) {
      return "Yesterday";
    }
    return DateFormat('dd:MM:yy')
        .format(DateTime.fromMillisecondsSinceEpoch(time2));
  }

  static Future<void> changeReadStatus(Message2 message) async {

    await api.firestore
        .collection("users_chats")
        .doc(api.getConversationID(message.fromId))
        .collection("messages")
        .doc(message.sendingTime)
        .update({
      "read": true,
    });
  }

// Update online status of the loggedin User

  static Future<void> updateOnlineStatus(bool isOnline) async {
    await firestore.collection("users").doc(user.uid).update({
      "is_online": isOnline,
    });
  }

  ////to get the last message of a chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String id) {
    return firestore
        .collection("users_chats")
        .doc(getConversationID(id))
        .collection("messages")
        .orderBy("sendingTime", descending: true)
        .limit(1)
        .snapshots();

  }

  /////Last message time
  static lastMessageTime(String time) {
    final intTime = int.parse(time);
    String time2 = DateTime.fromMillisecondsSinceEpoch(intTime).toString();
    final DateTime dateTime = DateTime.parse(time2);
    final String formattedTime =
        DateFormat('hh:mm a').format(dateTime).toString();
    if (DateTime.now().day == dateTime.day) {
      return formattedTime;
    }
    if (DateTime.now().day - 1 == dateTime.day) {
      return "Yesterday";
    }
    return formattedTime;
  }

  ////check for only emojis in the message
  static bool containsOnlyEmojis(String message) {
    // Define a regular expression pattern for matching emojis
    RegExp emojiRegex = RegExp(
      r'^[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]+$',
      unicode: true,
    );

    // Check if the message contains only emojis
    return emojiRegex.hasMatch(message);
  }

  ////check for whitespaces
  static bool isOnlyWhiteSpaces(String input) {
    // Define a regular expression pattern for matching spaces, tabs, and newlines
    RegExp whitespaceRegex = RegExp(r'^[ \t\n]+$');

    // Check if the input contains only spaces, tabs, and newlines
    return whitespaceRegex.hasMatch(input);
  }

  ///// permission handler code
  static Future<bool> checkAndRequestPermission(Permission permission) async {
    // Check the status of the given permission
    PermissionStatus status = await permission.status;

    if (status.isDenied) {
      // Request the permission if it's undetermined or denied
      status = await permission.request();
    }

    // Return true if the permission is granted, false otherwise
    return status.isGranted;
  }

////creating of getting the file name
  static createFileName(String sendingTime, String urlName) {
    String fileType = urlName.split('?').first.split('.').last;
    String fileName = "ChatApp-$sendingTime.$fileType";
    return fileName;
  }

  //// File exists or not
  static Future<bool> checkFileExists(
      String sendingTime, String urlName, String folderName) async {
    Directory? externalDir = await getExternalStorageDirectory();
    File file =
        File("${externalDir?.path}/$folderName/ChatApp-$sendingTime.$urlName");
    if (file.existsSync()) {
      return true;
    }
    return false;
    // return file.existsSync();
  }

  /////////////save the files to the app folder
  static Future<void> checkAndCreateDirectory(String customFolder) async {
    try {
      // Get the external storage directory
      Directory? externalDir = await getExternalStorageDirectory();

      // Create a new folder within the external storage directory
      Directory customDir = Directory('${externalDir?.path}/$customFolder');
      print(customDir.path);
      if (!customDir.existsSync()) {
        customDir.createSync();
        print('folder created');
      } else {
        print('folder already exists');
      }
    } catch (e) {
      print('Error in creating folder: $e');
    }
  }

  static Future<bool> downloadAndSaveFile(
      String fileUrl, String saveDirectory, String sendingTime) async {
    try {
      // Download the file
      final response = await http.get(Uri.parse(fileUrl));
      Directory? externalDir = await getExternalStorageDirectory();

//new lines added
      Directory customDir = Directory('${externalDir?.path}/$saveDirectory');
      print(customDir.path);
      if (!customDir.existsSync()) {
        customDir.createSync();
        print('folder created');
      } else {
        print('folder already exists');
      }

      File file = File(
          "$externalDir?.path}/$saveDirectory/${createFileName(sendingTime, fileUrl)}");
      if (file.existsSync()) {
        return true;
      }

      // return file.existsSync();

//ends here

      // checkAndCreateDirectory(saveDirectory);
      // checkFileExists(sendingTime, fileUrl, saveDirectory);
      if (response.statusCode == 200) {
        // Save the file to the specified path
        File file = File(
            "${externalDir?.path}/$saveDirectory/${createFileName(sendingTime, fileUrl)}");
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded and saved to: $saveDirectory');
        return true;
      } else {
        print(
            'Failed to download file. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading and saving file: $e');
    }
    return false;
  }

  ////getting app storge directory
static  Directory? externalDir = Directory('');
static String getExternalDirPath() {
    return externalDir!.path;
  }
  static Future<Directory?> getExternalDir() async {
    externalDir = await getExternalStorageDirectory();
    return externalDir;
  }

  static int currentPlayingIndex = -1;
  static getCurrentPlayingIndex() {
    return currentPlayingIndex;
  }
  static setCurrentPlayingIndex(int index) {
    currentPlayingIndex = index;
  }
}
