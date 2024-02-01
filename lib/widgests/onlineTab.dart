import 'package:chatapp/components/apis.dart';
import 'package:chatapp/widgests/contactCard.dart';
import 'package:flutter/material.dart';

class onlineTab extends StatefulWidget {
  const onlineTab({super.key});

  @override
  State<onlineTab> createState() => _onlineTabState();
}

class _onlineTabState extends State<onlineTab> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Color.fromARGB(242, 255, 255, 255)),
        // color: const Color.fromARGB(242, 255, 255, 255),
        child: StreamBuilder(
            stream: api.firestore
                .collection("users")
                .where("is_online", isEqualTo: true)
                .snapshots(),
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
      ),
    );
  }
}
