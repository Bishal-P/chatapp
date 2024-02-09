import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';

class appController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    print("The index is $selectedIndex");
  }

  int get index => selectedIndex.value;

// String messageTime
  String messageTime(String time2) {
    final now = DateTime.now();
    final DateTime time = DateTime.parse(time2);
    final difference = now.difference(time);
    if (difference.inDays > 1) {
      return "${time.day}/${time.month}/${time.year}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }

  //to check the record message button is active or not
  RxBool recordButton = false.obs;
  void changeRecordButton(bool value) {
    recordButton.value = value;
  }

  get getRecordButton => recordButton.value;

  ////audio player
  late final Directory? externalDir;
  get getExternalDir => externalDir;
  @override
  void onInit() async {
    externalDir = await getExternalStorageDirectory();
    super.onInit();
  }

  RxInt audioIndex = 0.obs;
  set setAudioIndex(int index) {
    audioIndex.value = index;
  }

  get getAudioIndex => audioIndex.value;

//searching user
  RxBool isSearching = true.obs;
  get getIsSearching => isSearching.value;
  set setIsSearching(bool value) {
    isSearching.value = value;
  }

  // search users data
  // RxList<Map<String, dynamic>> searchUsersData = <Map<String, dynamic>>[].obs;

  // get getSearchUsersData => searchUsersData;
  // set setSearchUsersData(List<Map<String, dynamic>> data) {
  //   searchUsersData.clear();
  //   searchUsersData.addAll(data);
  // }

  RxList<DocumentSnapshot<Object?>> searchUsersData2 =
      <DocumentSnapshot<Object?>>[].obs;
  get getSearchUsersData2 => searchUsersData2;
  set setSearchUsersData2(List<DocumentSnapshot<Object>> data) {
    searchUsersData2.clear();
    searchUsersData2.addAll(data);
  }

  clearSearchUsersData2() {
    searchUsersData2.clear();
  }
}
