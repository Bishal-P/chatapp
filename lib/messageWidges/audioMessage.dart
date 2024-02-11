import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
// import 'package:chatapp/components/audioplayerControls.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/pages/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class AudioPlayerController extends GetxController {
//   late final AudioPlayer audioPlayer;
//   bool audioInitialized = false;
//   bool isPlaying = false;
//   var currentPosition = Duration(seconds: 0)
//       .obs; // Observable variable for current playback position

//   late Timer _timer;

//   var duration = 0.obs;

//   get getDuration => duration.value;
//   set setDuration(value) => duration.value = value;

//   var totalDuration = Duration(seconds: 120).obs;
//   get getTotalDuration => totalDuration.value;

//   @override
//   void onInit() {
//     // super.onInit();
//     // audioPlayer = AudioPlayer();
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       // if (isPlaying) {
//       // If audio is playing, update currentPosition
//       currentPosition.value += Duration(seconds: 1);
//       // setDuration = currentPosition.value;
//       // }
//     });
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   void play(String url) async {
//     if (!audioInitialized) {
//       audioPlayer = AudioPlayer();
//       audioInitialized = true;
//     }
//     if (isPlaying) {
//       await audioPlayer.stop();
//       isPlaying = false;
//     }
//     audioPlayer.stop();
//     await audioPlayer.play(DeviceFileSource(url));
//     // setDuration = audioPlayer.getDuration() as Duration;
//     // setTotalDuration = audioPlayer.getDuration();
//     isPlaying = true;
//   }

//   void pause() async {
//     if (!isPlaying) {
//       await audioPlayer.pause();
//       isPlaying = true;
//     }
//     if (isPlaying) {
//       await audioPlayer.pause();
//       isPlaying = false;
//     }
//     await audioPlayer.pause();
//   }

//   void stop() async {
//     if (!audioInitialized) {
//       audioPlayer = AudioPlayer();
//       audioInitialized = true;
//     }
//     if (isPlaying) {
//       await audioPlayer.stop();
//       isPlaying = false;
//     }
//     await audioPlayer.stop();
//   }

//   void seek(double value) {
//     audioPlayer.seek(Duration(milliseconds: value.toInt()));
//     currentPosition.value = Duration(milliseconds: value.toInt());
//     // setDuration = Duration(milliseconds: value.toInt());
//   }
// }

class audioController extends GetxController {
  appController appControl = Get.find<appController>();
  late AudioPlayer audioPlayer;
  RxBool audioInitialized = false.obs;

  get getAudioInitialized => audioInitialized.value;
  set setAudioInitialized(value) => audioInitialized.value = value;

  RxBool isPlaying = false.obs;
  set setIsPlaying(value) => isPlaying.value = value;
  get getIsPlaying => isPlaying.value;

  var totalDuration = Duration(seconds: 0).obs;
  get getTotalDuration => totalDuration.value;
  set setTotalDuration(value) => totalDuration.value = value;

  void play(String url, int index) async {
    if (getAudioInitialized == false) {
      audioPlayer = AudioPlayer();
      // audioInitialized = true;
      setAudioInitialized = true;
      api.currentPlayingIndex = index;
      print("The audio player is initialized");
      // setTotalDuration = await audioPlayer.getDuration();
    }
    if (getIsPlaying) {
      await audioPlayer.pause();
      setIsPlaying = false;
    } else {
      await audioPlayer.play(DeviceFileSource(url));
      setIsPlaying = true;
    }
  }

  var currentPosition = Duration(seconds: 0).obs;
  get getCurrentPosition => currentPosition.value;
  set setCurrentPosition(value) => currentPosition.value = value;
  // set setCurrentPosition(value) => currentPosition.value = value;
  // get getCurrentPosition => currentPosition.value;
  // late Timer _timer;
  // @override
  // void onInit() {
  //   super.onInit();
  //   // Start a timer to update currentPosition every second
  //   _timer = Timer.periodic(Duration(seconds: 1), (_) {
  //     // if (isPlaying.value) {
  //     // If audio is playing, update currentPosition
  //     currentPosition.value += Duration(seconds: 1);
  //     print("The current position is ${currentPosition.value}");
  //     // }
  //   });
  void seekDuration(double value) {
    if (getIsPlaying) {
      audioPlayer.seek(Duration(milliseconds: value.toInt()));
      currentPosition.value = Duration(milliseconds: value.toInt());
    }
    // audioPlayer.seek(Duration(milliseconds: value.toInt()));
    // currentPosition.value = Duration(milliseconds: value.toInt());
  }

  @override
  void dispose() {
    if (getAudioInitialized) {
      audioPlayer.dispose();
    }
    super.dispose();
  }

  RxBool isDownloaded = false.obs;
  set setIsDownloaded(value) => isDownloaded.value = value;
  get getIsDownloaded => isDownloaded.value;
}

class audioMessage extends StatefulWidget {
  final Message2? message;
  final int index;
  const audioMessage({super.key, this.message, required this.index});

  @override
  State<audioMessage> createState() => _audioMessageState();
}

class _audioMessageState extends State<audioMessage> {
  final audioController controller = audioController();
  final appController appControl = Get.put(appController());
  // bool isPlying = false;
  // bool isFileExist = false;
  // String filePath = "";
  String fileName = "";
  late Timer timer;
  int duration = 0;
  String filePath = "";

  @override
  void dispose() {
    // audioPlayerController.dispose();
    print("The audio player is disposed");
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.setCurrentPosition = Duration(seconds: 0);
    filePath = api.getExternalDirPath();
    fileName =
        api.createFileName(widget.message!.sendingTime, widget.message!.msg);
    api
        .downloadAndSaveFile(
            widget.message!.msg, "audio", widget.message!.sendingTime)
        .then((value) => print("The file is downloaded $value"));
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (api.currentPlayingIndex != widget.index) {
        if (controller.getAudioInitialized) {
          controller.audioPlayer.pause();
          controller.audioPlayer.dispose();
          controller.setAudioInitialized = false;
        }
        controller.setIsPlaying = false;
        controller.setCurrentPosition = Duration(seconds: 0);
      }
      if (controller.getIsPlaying) {
        appControl.setAudioIndex = widget.index;
        controller.setCurrentPosition =
            Duration(seconds: controller.getCurrentPosition.inSeconds + 1);

        print(
            "The audio player is working ${controller.currentPosition.value}");
      }
      if (controller.getCurrentPosition.inSeconds - 2 ==
          controller.getTotalDuration.inSeconds) {
        controller.setIsPlaying = false;
        controller.setCurrentPosition = Duration(seconds: 0);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final AudioPlayerController audioPlayerController = AudioPlayerController();

    // int timer = 0;
    // audioPlayerController.play(
    //     "/storage/emulated/0/Android/data/com.example.chatapp/files/audio/chatApp-${widget.message!.sendingTime}.mp3");
    return Row(
      mainAxisAlignment: widget.message?.fromId == api.user.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Obx(() {
          // timer++;
          print("The audio player is working ${appControl.getAudioIndex}");
          return Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              color: Color.fromARGB(185, 80, 206, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // if (appControl.getAudioIndex != widget.index) {
                    //   controller.audioPlayer.stop();
                    //   controller.setIsPlaying = false;
                    //   controller.setCurrentPosition = Duration(seconds: 0);
                    // }

                    controller.play(
                        "${filePath}/audio/${fileName}", widget.index);
                    try {
                      controller.audioPlayer.onDurationChanged
                          .listen((duration) {
                        setState(() {
                          controller.setTotalDuration = duration;
                        });
                      });
                    } catch (e) {
                      print("The error is $e");
                    }
                  },
                  icon: Icon(
                    controller.getIsPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: ProgressBar(
                    thumbRadius: 0,
                    timeLabelTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 13),
                    baseBarColor: Colors.white,
                    progress: controller.getCurrentPosition,
                    // Use current position as progress
                    // total: audioPlayerController
                    //     .getDuration, // Total duration of the audio
                    total: controller.getTotalDuration,
                    onSeek: (duration) {
                      double seek = duration.inMilliseconds.toDouble();
                      controller.seekDuration(seek);
                      // audioPlayerController.seek(seek);
                      print('User selected a new time: $duration');
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Widget build(BuildContext context) {
  //   print("The message is working${widget.message!.msg}");
  //   print("The widget is working");
  // final AudioPlayerController audioPlayerController =
  //     Get.find<AudioPlayerController>();

  //   return Row(
  //     mainAxisAlignment: widget.message?.toId == api.user.uid
  //         ? MainAxisAlignment.start
  //         : MainAxisAlignment.end,
  //     children: [
  //       Container(
  //         width: 200,
  //         height: 60,
  //         decoration: BoxDecoration(
  //           color: Color.fromARGB(185, 80, 206, 255),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Row(
  //           children: [
  //             IconButton(
  //               onPressed: () {
  //                 if (audioPlayerController.isPlaying) {
  //                   audioPlayerController.pause();
  //                 } else {
  //                   // audioPlayerController.play();

  //                   print("Playing audio");
  //                   // audioControls.play(filePath, 1);
  //                   audioPlayerController.play(
  //                       "/storage/emulated/0/Android/data/com.example.chatapp/files/audio/chatApp-${widget.message!.sendingTime}.mp3");
  //                   setState(() {
  //                     // isPlying = true;
  //                   });
  //                 }
  //               },
  //               icon: audioPlayerController.isPlaying
  //                   ? const Icon(
  //                       Icons.pause_circle_filled,
  //                       size: 40,
  //                       color: Colors.white,
  //                     )
  //                   : const Icon(Icons.play_circle_filled,
  //                       size: 40, color: Colors.white),
  //             ),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width * 0.32,
  //               child: ProgressBar(
  //                 thumbRadius: 0,
  //                 timeLabelTextStyle:
  //                     const TextStyle(color: Colors.white, fontSize: 13),
  //                 baseBarColor: Colors.white,
  //                 progress: audioPlayerController.currentPosition.value,
  //                 buffered: Duration(milliseconds: 2000),
  //                 total: audioPlayerController.getDuration,
  //                 onSeek: (duration) {
  //                   double seek = duration.inMilliseconds.toDouble();
  //                   audioPlayerController.seek(seek);
  //                   print('User selected a new time: $duration');
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
