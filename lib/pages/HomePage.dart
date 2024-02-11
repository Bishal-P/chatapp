import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/pages/searchScreen.dart';
import 'package:chatapp/widgests/messagesTab.dart';
import 'package:chatapp/widgests/popUpMenu.dart';
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

  List<DocumentSnapshot<Object>> usersList = [];
  Set<String> uniqueIds = {};

  Future<Map<String, dynamic>> searchUsers(String substring) async {
    if (substring == "") {
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

          uniqueIds.add(docId); // Add document ID to the set
        }
      });

      controller.setSearchUsersData2 = usersList;
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

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        api.updateOnlineStatus(true);

        break;
      case AppLifecycleState.paused:
        api.updateOnlineStatus(false);

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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Obx(
            () {
              return !controller.getIsSearching
                  ? Container(
                      color: Colors.transparent,
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        autofocus: true,
                        maxLines: 1,
                        onChanged: (value) async {
                          searchUsers(value);
                        },
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Search",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
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
                          color: Color.fromARGB(221, 255, 255, 255)),
                    );
            },
          ),
          actions: [
            Obx(() => IconButton(
                  onPressed: () {
                    controller.setIsSearching = !controller.getIsSearching;
                  },
                  icon: !controller.getIsSearching
                      ? const Icon(
                          Icons.cancel,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                )),
            const popUpMenu(),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage("assets/2.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Obx(() {
              return !controller.getIsSearching
                  ? const searchScreen()
                  // ? SizedBox()
                  : Column(
                      children: [
                        Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: AssetImage("assets/2.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // CategorySelector(),
                        messagesTab(),
                      ],
                    );
            })));
  }
}
