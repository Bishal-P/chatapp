import 'package:chatapp/components/apis.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

Widget recordAudio(String toId) {
  return Positioned(
    bottom: 8,
    right: 8,
    child: SocialMediaRecorder(
      fullRecordPackageHeight: 50.0,
      initRecordPackageWidth: 50.0,
      backGroundColor: Colors.greenAccent,
      radius: BorderRadius.circular(30),
      // sendButtonIcon: Icon(Icons.send),
      recordIconWhenLockBackGroundColor: Color.fromARGB(255, 45, 143, 255),
      recordIcon: const Icon(
        Icons.mic,
        color: Colors.white,
        size: 30,
      ),
      startRecording: () {
        print("start recording");
        // function called when start recording
      },
      stopRecording: (_time) {
        print("the recording time is $_time");
        // function called when stop recording, return the recording time
      },
      sendRequestFunction: (soundFile, _time) {
        print("the current path is ${soundFile.path}");
        api.sendFile(toId, soundFile, Type.audio);
      },
      encode: AudioEncoderType.AAC,
    ),
  );
}
