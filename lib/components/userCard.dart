import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/pages/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chartUsercard extends StatefulWidget {
  // var name;
  // var about;
  DocumentSnapshot<Object>? doc;
  chartUsercard({super.key, this.doc});

  @override
  State<chartUsercard> createState() => _chartUsercardState();
}

class _chartUsercardState extends State<chartUsercard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(doc: widget.doc!)));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: widget.doc!['image'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.person,
                size: 30,
              ),
            ),
          ),
          //  CircleAvatar(
          //   child: Icon(Icons.person),
          // ),
          title: Text(widget.doc!['name']),
          subtitle: Text(widget.doc!['about']),
          trailing: const Icon(Icons.message),
        ),
      ),
    );
  }
}
