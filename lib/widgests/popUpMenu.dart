import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/ProfileScreen.dart';
import 'package:chatapp/pages/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class popUpMenu extends StatelessWidget {
  // final DocumentSnapshot? doc;
  const popUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? doc;
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Profile"),
        ),
        PopupMenuItem(
          onTap: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              print("The logout value is true");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const loginPage()));
            });
          },
          value: 2,
          child: const Text("Sign Out"),
        ),
      ],
      onSelected: (value) async {
        if (value == 1) {
          await api.firestore.collection("users").doc(api.user.uid).get().then(
            (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            doc: value,
                          )));
              doc = value;
            },
          );
        } else {
          Null;
        }
      },
    );
  }
}
