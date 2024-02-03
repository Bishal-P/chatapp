import 'package:chatapp/components/appController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget uploadProgress() {
  return Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10,
        ),
        Obx(() => Text("Uploading...${appController().progress}")),
      ],
    ),
  );
}
