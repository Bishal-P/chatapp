import 'package:chatapp/components/apis.dart';
import 'package:flutter/material.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

// class testVoice extends StatefulWidget {
//   const testVoice({super.key});

//   @override
//   State<testVoice> createState() => _testVoiceState();
// }

// class _testVoiceState extends State<testVoice> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 200),
//               child: Align(
//                   alignment: Alignment.centerRight,
//                   child: SocialMediaRecorder(
//                     fullRecordPackageHeight: 60.0,
//                     initRecordPackageWidth: 60.0,
//                     backGroundColor: Colors.blue,
//                     radius: BorderRadius.circular(20),
//                     // sendButtonIcon: Icon(Icons.send),
//                     recordIcon: Icon(
//                       Icons.mic,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     startRecording: () {
//                       print("start recording");
//                       // function called when start recording
//                     },
//                     stopRecording: (_time) {
//                       print("the recording time is $_time");
//                       // function called when stop recording, return the recording time
//                     },
//                     sendRequestFunction: (soundFile, _time) {
//                       print("the current path is ${soundFile.path}");
//                       api.sendImage(api.user.uid, soundFile);
//                     },
//                     encode: AudioEncoderType.AAC,
//                   )),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }

Widget recordAudio() {
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
        api.sendImage(api.user.uid, soundFile);
      },
      encode: AudioEncoderType.AAC,
    ),
  );
}
