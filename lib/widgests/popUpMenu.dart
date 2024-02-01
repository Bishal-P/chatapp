import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/ProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class popUpMenu extends StatelessWidget {
  // final DocumentSnapshot? doc;
  const popUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? doc;
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Profile"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Sign Out"),
          value: 2,
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
              print("The doc is ${doc?['name']}");
              print("The type of doc is ${value!.runtimeType}");
            },
          );

          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        } else {
          print("Delete");
        }
      },
    );
  }
}
