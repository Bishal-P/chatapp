import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/imageViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget imageMessage(
    {required message,
    required image_list,
    required imageIndex,
    required index,
    required context}) {
  print("The message is working${message.msg}");
  print(api.checkFileExists(message.sendingTime, message.msg, "image"));
  return InkWell(
    onTap: () {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => image_viewer(
                imageList: image_list,
                index: imageIndex != {} ? imageIndex[index]! : 0,
              ));
    },
    child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 44, 110, 253),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(0)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              filterQuality: FilterQuality.low,
              imageUrl: message.msg,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ))),
  );
}
