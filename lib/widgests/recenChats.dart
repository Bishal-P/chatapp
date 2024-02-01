import 'package:chatapp/components/apis.dart';
import 'package:chatapp/widgests/contactCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({super.key});

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  // DocumentSnapshot? doc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: const Color.fromARGB(242, 255, 255, 255),
      child: StreamBuilder(
          stream: api.firestore.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No chats"),
              );
            }
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data?.docs[index].id == api.user.uid) {
                    return const SizedBox();
                  }
                  return contactCard(snapshot: snapshot, index: index);
                });
          }),
    ));
  }
}