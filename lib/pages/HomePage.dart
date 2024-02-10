// import 'package:chatapp/newPages/category_selector.dart';
// import 'package:chatapp/newPages/favorite_contacts.dart';s
// import 'package:chatapp/newPages/recent_chats.dart';
// import 'dart:html';

import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/pages/searchScreen.dart';
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

  // List<Map<String, dynamic>> usersList = [];
  List<DocumentSnapshot<Object>> usersList = [];
  Set<String> uniqueIds = {};

  Future<Map<String, dynamic>> searchUsers(String substring) async {
    if (substring == "") {
      // controller.setSearchUsersData = [];
      controller.clearSearchUsersData2();
      usersList.clear();
      uniqueIds.clear();
    }
    usersList.clear();
    uniqueIds.clear();
    try {
      // Convert the substring to lowercase
      substring = substring.toLowerCase();

      // Preprocess data and update 'nameSubstrings' field in Firestore documents
      await preprocessData(substring);

      // Query Firestore for documents where the 'nameSubstrings' array contains the substring
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Replace 'users' with your collection name
          .where('nameSubstrings', arrayContains: substring)
          .get();

      querySnapshot.docs.forEach((doc) {
        print("type of doc is ${doc.runtimeType}"); // QueryDocumentSnapshot
        String docId = doc['id'];
        print("The doc id is $docId");
        if (!uniqueIds.contains(docId)) {
          // controller.setSearchUsersData2 = doc as DocumentSnapshot<Object?>;
          usersList.add(doc as DocumentSnapshot<Object>);
          // Map<String, dynamic> data =
          //     (doc.data() as Map<String, dynamic>?) ?? {};
          // usersList.add(data);
          // // docs.add(doc);
          uniqueIds.add(docId); // Add document ID to the set
        }
      });

      controller.setSearchUsersData2 = usersList;

      // querySnapshot.docs.forEach((doc) {
      //   data = (doc.data() as Map<String, dynamic>?) ?? {};

      //   // Print or process the data as needed
      //   print(data['name']);
      // });
    } catch (e) {
      print('Error: $e');
    }
    return {};
  }

  Future<void> preprocessData(String substring) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String name = doc['name'].toLowerCase();
        List<String> substrings = [];
        for (int i = 0; i < name.length; i++) {
          for (int j = i + 1; j <= name.length; j++) {
            substrings.add(name.substring(i, j));
          }
        }
        await doc.reference.update({'nameSubstrings': substrings});
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
    // CollectionReference messages =
    //     FirebaseFirestore.instance.collection('users');

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Obx(
            () {
              return !controller.getIsSearching
                  ? Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        autofocus: true,
                        maxLines: 1,
                        onChanged: (value) async {
                          searchUsers(value);
                          // QuerySnapshot querySnapshot = await FirebaseFirestore
                          //     .instance
                          //     .collection(
                          //         'users') // Replace 'users' with your collection name
                          //     .where('name', isEqualTo: value)
                          //     .get();

                          // querySnapshot.docs.forEach((doc) {
                          //   print(doc.data());
                          // });

                          // print("The value is $value");
                        },
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Search",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                        ),
                      ),
                    )
                  : const Text(
                      "NeoChat",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.black87),
                    );
            },
          ),
          actions: [
            Obx(() => IconButton(
                  onPressed: () {
                    controller.setIsSearching = !controller.getIsSearching;
                  },
                  icon: !controller.getIsSearching
                      ? const Icon(Icons.cancel)
                      : const Icon(Icons.search),
                )),
            const popUpMenu(),
          ],
        ),
        body: Obx(() {
          return !controller.getIsSearching
              ? searchScreen()
              // ? SizedBox()
              : Column(
                  children: [
                    CategorySelector(),
                    tabs[controller.index],
                  ],
                );
        }));
  }
}
