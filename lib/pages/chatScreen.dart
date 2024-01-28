import 'package:chatapp/components/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  DocumentSnapshot<Object>? doc;
  ChatScreen({super.key, this.doc});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    print("The doc id is ${widget.doc!}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          automaticallyImplyLeading: false,
          flexibleSpace: Row(
            children: [
              // IconButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     icon: const Icon(Icons.arrow_back)),
              // ListTile(
              //   leading: CircleAvatar(
              //     child: Icon(Icons.person),
              //   ),
              //   title: Text(widget.doc!),
              //   subtitle: Text("Last seen at 12:00"),
              // )
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    height: 50,
                    image: AssetImage(
                      "assets/login.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.doc!['name'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    Text("Last seen at 12:00",
                        style: const TextStyle(
                          fontSize: 10,
                        ))
                  ],
                ),
              )
            ],
          ),
          // leading:
          // centerTitle: true,
        ),
      ),
    );
  }
}
