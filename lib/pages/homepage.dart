import 'dart:convert';

import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/userCard.dart';
import 'package:chatapp/pages/ProfileScreen.dart';
import 'package:chatapp/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
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
    });

    // api.createUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
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
                // print(snapshot.data?.docs);
                // final data = snapshot.data?.docs;
                // for (var i in data!) {
                //   log("data : ${jsonEncode(i.data())}}");
                //   print("data");
                //   print(i.data() as Map<String, dynamic>);
                // }
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      // print(
                      // "The snapshot data is ${snapshot.data?.docs[index].id}");
                      if (snapshot.data?.docs[index].id == api.user.uid) {
                        print("the value is true");
                      } else {
                        print("The snapshot data is ${snapshot.data?.docs}");
                        return chartUsercard(
                            name: snapshot.data?.docs[index]["name"],
                            about: snapshot.data?.docs[index]["about"]);
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
