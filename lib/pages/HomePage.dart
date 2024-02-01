// import 'package:chatapp/newPages/category_selector.dart';
// import 'package:chatapp/newPages/favorite_contacts.dart';s
// import 'package:chatapp/newPages/recent_chats.dart';
// import 'dart:html';

import 'package:chatapp/components/apis.dart';
import 'package:chatapp/widgests/CategorySelector.dart';
import 'package:chatapp/widgests/favouriteContacts.dart';
import 'package:chatapp/widgests/popUpMenu.dart';
import 'package:chatapp/widgests/recenChats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  DocumentSnapshot? doc;
  // List users = ["user1", "user2", "user3", "user4", "user5", "user6"];
  // List favUsers = ["user1", "user2", "user3", "user4", "user5", "user6"];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    api.userExist().then((value) {
      if (value == true) {
        print("User Exist");
      } else {
        api.createUser();
        print("User does not Exist");
      }
      print("The user id is ${api.user.uid}");
      print("The result is ${value}");
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    api.firestore.collection("users").doc(api.user.uid).update({
      "is_online": false,
    }).then((value) => print("Updated successfully"));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        api.firestore.collection("users").doc(api.user.uid).update({
          "is_online": true,
        }).then((value) => print("Updated successfully"));
        //Execute the code here when user come back the app.
        //In my case, I needed to show if user active or not,

        break;
      case AppLifecycleState.paused:
        //Execute the code the when user leave the app
        api.firestore.collection("users").doc(api.user.uid).update({
          "is_online": false,
        }).then((value) => print("Updated successfully"));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          "NeoChat",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          const popUpMenu(),
        ],
      ),
      body: Column(
        children: [
          CategorySelector(),
          Expanded(
              child: Container(
            child: Column(
              children: [FavourtieContacts(), RecentChats()],
            ),
          ))
        ],
      ),
    );
  }
}
