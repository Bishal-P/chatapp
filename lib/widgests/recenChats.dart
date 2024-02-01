import 'package:chatapp/components/apis.dart';
import 'package:chatapp/widgests/contactCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({super.key});

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

List users = ["user1", "user2", "user3", "user4", "user5", "user6"];

class _RecentChatsState extends State<RecentChats> {
  // DocumentSnapshot? doc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Color.fromARGB(242, 255, 255, 255),
      child: StreamBuilder(
          stream: api.firestore.collection("users").snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  // print("The saved user id is ${api.user.uid}");
                  // print("The useri is ${snapshot.data?.docs[index].id}");
                  if (snapshot.data?.docs[index].id == api.user.uid) {
                    return SizedBox();
                  }
                  return contactCard(snapshot: snapshot, index: index);
                });
          }),
    ));
  }
}
