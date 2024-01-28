import 'package:chatapp/components/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String? doc;
  ChatScreen({super.key, this.doc});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    print("The doc id is ${widget.doc!}");
    return Scaffold(
      appBar: AppBar(
          leading: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(widget.doc!),
            subtitle: Text("Last seen at 12:00"),
          ),
          // centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.black))
          ]),
    );
  }
}
