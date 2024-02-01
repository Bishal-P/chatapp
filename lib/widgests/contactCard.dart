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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      doc: widget.snapshot.data?.docs[widget.index])));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.snapshot.data?.docs[widget.index]['image'].isEmpty
                    ? CircleAvatar(
                        radius: 30,
                        child: Text(
                            widget.snapshot.data?.docs[widget.index]["name"][0]
                                .toUpperCase(),
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.network(
                          widget.snapshot.data?.docs[widget.index]['image'],
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
                      widget.snapshot.data?.docs[widget.index]['name'],
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
                      child: const Text(
                        "Hello how are you doing today",
                        // chat.text,
                        style: TextStyle(
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
                const Text(
                  "4:00 PM",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                // chat.unread
                true
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
                    : Text(''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
