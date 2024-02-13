// import 'dart:js_interop';

// import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
// import 'package:chatapp/models/usermodel.dart';
import 'package:chatapp/pages/chatScreen.dart';
// import 'package:chatapp/widgests/contactCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class searchScreen extends StatelessWidget {
  const searchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appController _controller = Get.put(appController());
    return Container(
      color: Color.fromARGB(255, 240, 240, 240),
      height: MediaQuery.of(context).size.height,
      child: Obx(() => ListView.builder(
            itemCount: _controller.searchUsersData2.length,
            itemBuilder: (context, index) {
              final data = _controller.searchUsersData2[index];
              print("The data is $data");
              return InkWell(
                onTap: () {
                  Get.to(() => ChatScreen(
                        doc: data as DocumentSnapshot<Object>,
                      ));
                },
                child: Card(
                  elevation: 0.0,
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
                              // snapshot.data?.docs[index]['image'].isEmpty
                              data['image'].isEmpty
                                  ? CircleAvatar(
                                      radius: 30,
                                      child: Text(
                                        // snapshot.data?.docs[index]['name']
                                        data['name']
                                                .toString()
                                                .substring(0, 1) ??
                                            'No Name',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          // snapshot.data?.docs[index]
                                          // ['image']),
                                          data['image']),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // add this
                                children: <Widget>[
                                  Text(
                                    // snapshot.data?.docs[index]['name'],
                                    data['name'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    // snapshot.data?.docs[index]['email'],
                                    data['email'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
