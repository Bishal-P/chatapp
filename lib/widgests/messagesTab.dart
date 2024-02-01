import 'package:chatapp/widgests/favouriteContacts.dart';
import 'package:chatapp/widgests/recenChats.dart';
import 'package:flutter/material.dart';

Widget messagesTab() {
  return const Expanded(
      child: Column(
    children: [FavourtieContacts(), RecentChats()],
  ));
}
