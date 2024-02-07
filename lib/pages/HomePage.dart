// import 'package:chatapp/newPages/category_selector.dart';
// import 'package:chatapp/newPages/favorite_contacts.dart';s
// import 'package:chatapp/newPages/recent_chats.dart';
// import 'dart:html';

import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/widgests/CategorySelector.dart';
// import 'package:chatapp/widgests/favouriteContacts.dart';
import 'package:chatapp/widgests/groupsTab.dart';
import 'package:chatapp/widgests/messagesTab.dart';
import 'package:chatapp/widgests/onlineTab.dart';
import 'package:chatapp/widgests/popUpMenu.dart';
// import 'package:chatapp/widgests/recenChats.dart';
import 'package:chatapp/widgests/requestTab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  DocumentSnapshot? doc;
  final appController controller = Get.put(appController());
  // List users = ["user1", "user2", "user3", "user4", "user5", "user6"];
  // List favUsers = ["user1", "user2", "user3", "user4", "user5", "user6"];
  List<Widget> tabs = [
    messagesTab(),
    const onlineTab(),
    const groupTab(),
    const requestTab()
  ];
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
    api.updateOnlineStatus(true);
    api.getExternalDir();
    super.initState();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    api.updateOnlineStatus(false);
    // await api.firestore.collection("users").doc(api.user.uid).update({
    //   "is_online": false,
    // }).then((value) => print("Updated successfully"));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        api.updateOnlineStatus(true);
        // await api.firestore.collection("users").doc(api.user.uid).update({
        //   "is_online": true,
        // }).then((value) => print("online is true Updated successfully"));
        //Execute the code here when user come back the app.
        //In my case, I needed to show if user active or not,

        break;
      case AppLifecycleState.paused:
        api.updateOnlineStatus(false);
        //Execute the code the when user leave the app
        // await api.firestore.collection("users").doc(api.user.uid).update({
        //   "is_online": false,
        // }).then((value) => print("online is false Updated successfully"));
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
          Obx(() => tabs[controller.index]),
        ],
      ),
    );
  }
}
