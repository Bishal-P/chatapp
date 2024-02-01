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




// here to change the focus of the selected text of the chatscreen

  FocusNode focusNode = FocusNode();

  void unFocus() {
    focusNode.unfocus();
  }
}
