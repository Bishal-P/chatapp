import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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


  // listening the upload status
  RxBool isUploading = false.obs;
  RxInt uploadProgress = 0.obs;
  int get progress => uploadProgress.value;
  bool get uploading => isUploading.value;
  void setUploading(bool value) {
    isUploading.value = value;
  }
  void setUploadProgress(int value) {
    uploadProgress.value = value;
  }
  
}
