import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';

class audioMessage extends StatefulWidget {
  final Message2? message;
  const audioMessage({super.key, this.message});

  @override
  State<audioMessage> createState() => _audioMessageState();
}

class _audioMessageState extends State<audioMessage> {
  @override
  Widget build(BuildContext context) {
    print("The message is working${widget.message!.msg}");
    print("The widget is working");
    return Row(
      mainAxisAlignment: widget.message?.toId == api.user.uid
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(186, 136, 131, 131),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  print("Playing audio");
                  api.audioPlayer.play(AssetSource(
                      "/storage/emulated/0/Android/data/com.example.chatapp/files/audio/chatApp-${widget.message!.sendingTime}.m4a"));
                  api.downloadAndSaveFile(widget.message!.msg, "audio",
                      widget.message!.sendingTime);
                },
                icon: Icon(Icons.play_arrow),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.32,
                child: const LinearProgressIndicator(
                  value: 0.4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 135, 219, 56)),
                  backgroundColor: Color.fromARGB(255, 230, 226, 226),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
