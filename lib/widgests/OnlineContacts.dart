import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class onlineContacts extends StatefulWidget {
  const onlineContacts({super.key});

  @override
  State<onlineContacts> createState() => _onlineContactsState();
}

class _onlineContactsState extends State<onlineContacts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(240, 48, 46, 46),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      height: 170,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "Online Users",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          Flexible(
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data?.docs[index].id == api.user.uid) {
                          return const SizedBox();
                        }
                        return InkWell(
                          onTap: () => Get.to(() => ChatScreen(
                                doc: snapshot.data?.docs[index],
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data?.docs[index]['image'].isEmpty
                                    ? CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 0, 255, 132),
                                        radius: 32,
                                        child: CircleAvatar(
                                            radius: 28,
                                            child: Text(
                                                snapshot.data
                                                    ?.docs[index]["name"][0]
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black))),
                                      )
                                    : CircleAvatar(
                                        radius: 32,
                                        backgroundColor: const Color.fromARGB(
                                            255, 0, 255, 132),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          child: Image.network(
                                            snapshot.data?.docs[index]['image'],
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 6.0,
                                ),
                                Text(
                                  snapshot.data?.docs[index]['name'],
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}
