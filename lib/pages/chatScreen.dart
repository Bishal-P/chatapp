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
          backgroundColor: Color.fromARGB(71, 68, 67, 67),
          automaticallyImplyLeading: false,
          flexibleSpace: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
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
        ),
        body: Expanded(
          child: Column(
            children: [
              Expanded(
                  child: Text("This is the chat screen",
                      style: const TextStyle(fontSize: 20))),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(100)),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions_outlined,
                            color: Colors.black)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          enableSuggestions: true,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message"),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.attach_file, color: Colors.black)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Colors.black)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
