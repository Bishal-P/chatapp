import 'dart:convert';
// import 'dart:html';

import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/userCard.dart';
import 'package:chatapp/pages/ProfileScreen.dart';
import 'package:chatapp/pages/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  DocumentSnapshot? doc;

  @override
  void initState() {
    // api.firestore.collection("users").doc(api.user.uid).get().then(
    //   (value) {
    //     doc = value;
    //     print("The doc is ${doc?['name']}");
    //     print("The type of doc is ${value!.runtimeType}");
    //   },
    // );
    // print("The doc is ${doc}");
    // api.firestore.collection('users').doc().get().then((docSnapshot) => {
    //       if (docSnapshot.exists)
    //         {print('Document exists on the database')}
    //       else
    //         {print('Document does not exist on the database')}
    //     });
    api.userExist().then((value) {
      if (value == true) {
        print("User Exist");
      } else {
        api.createUser();
        print("User does not Exist");
      }
      print("The user id is ${api.user.uid}");
      print("The result is ${value}");

      api.firestore.collection("users").doc(api.user.uid).update({
        "is_online": true,
      }).then((value) => print("Updated successfully"));
    });

    // api.createUser();
    super.initState();
  }

  @override
  void dispose() {
    api.firestore.collection("users").doc(api.user.uid).update({
      "is_online": false,
    }).then((value) => print("Updated successfully"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () async {
              await api.firestore
                  .collection("users")
                  .doc(api.user.uid)
                  .get()
                  .then(
                (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                doc: value,
                              )));
                  doc = value;
                  print("The doc is ${doc?['name']}");
                  print("The type of doc is ${value!.runtimeType}");
                },
              );
            },
            child: const Icon(Icons.home),
          ),
          title: const Text('Home Page'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    print("The logout value is true");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const loginPage()));
                  });
                  // return Future.delayed(Duration.zero, () {
                  //   return Center(child: CircularProgressIndicator());
                  // });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder(
            stream: api.firestore.collection("users").snapshots(),
            builder: (context, snapshot) {
              // print(snapshot.data?.docs);
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      print(
                          "The snapshot data is ${snapshot.data?.docs[index]}");
                      if (snapshot.data?.docs[index].id != api.user.uid) {
                        return chartUsercard(doc: snapshot.data?.docs[index]);
                      }
                      return const SizedBox();
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
