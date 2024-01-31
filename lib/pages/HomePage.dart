// import 'package:chatapp/newPages/category_selector.dart';
// import 'package:chatapp/newPages/favorite_contacts.dart';s
// import 'package:chatapp/newPages/recent_chats.dart';
import 'package:chatapp/widgests/CategorySelector.dart';
import 'package:chatapp/widgests/favouriteContacts.dart';
import 'package:chatapp/widgests/recenChats.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List users = ["user1", "user2", "user3", "user4", "user5", "user6"];
  List favUsers = ["user1", "user2", "user3", "user4", "user5", "user6"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          "NeoChat",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          CategorySelector(),
          Expanded(
              child: Container(
            // decoration: const BoxDecoration(
            //   // color: Theme.of(context).accentColor,
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(1.0),
            //     topRight: Radius.circular(1.0),
            //   ),
            // ),
            child: Column(
              children: [FavourtieContacts(), RecentChats()],
            ),
          ))
        ],
      ),
    );
  }
}
