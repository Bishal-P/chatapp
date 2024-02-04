import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/chatScreen.dart';
import 'package:flutter/material.dart';

class contactCard extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const contactCard({super.key, required this.snapshot, required this.index});

  @override
  State<contactCard> createState() => _contactCardState();
}

class _contactCardState extends State<contactCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(doc: widget.snapshot.data?.docs[widget.index])));
      },
      child: StreamBuilder(
          stream: api
              .getLastMessage(widget.snapshot.data?.docs[widget.index]['id']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const Text("No recent messages"));
            }
            if (snapshot.data?.docs.length == 0) {
              return const SizedBox();
            }
            print(
                "The length of the snapshot is ${snapshot.data?.docs.length}");
            return Card(
              elevation: 0.0,
              color: snapshot.data?.docs[0]['read'] == false &&
                      snapshot.data?.docs[0]['toId'] !=
                          widget.snapshot.data?.docs[widget.index]['id']
                  ? Color.fromARGB(255, 211, 235, 210)
                  : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: SizedBox(
                  // color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          widget.snapshot.data?.docs[widget.index]['image']
                                  .isEmpty
                              ? CircleAvatar(
                                  radius: 30,
                                  child: Text(
                                      widget.snapshot.data
                                          ?.docs[widget.index]["name"][0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Image.network(
                                    widget.snapshot.data?.docs[widget.index]
                                        ['image'],
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.snapshot.data?.docs[widget.index]
                                    ['name'],
                                // chat.sender.name,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 44, 44, 44),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  snapshot.data?.docs[0]['msg'],
                                  // chat.text,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            api.lastMessageTime(
                                snapshot.data?.docs[0]['sentTime']),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          // chat.unread
                          snapshot.data?.docs[0]['read'] == false &&
                                  snapshot.data?.docs[0]['toId'] !=
                                      widget.snapshot.data?.docs[widget.index]
                                          ['id']
                              ? Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
