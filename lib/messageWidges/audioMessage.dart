import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/components/appController.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void seekDuration(double value) {
    if (getIsPlaying) {
      audioPlayer.seek(Duration(milliseconds: value.toInt()));
      currentPosition.value = Duration(milliseconds: value.toInt());
    }
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
      }
      if (controller.getCurrentPosition.inSeconds - 2 ==
          controller.getTotalDuration.inSeconds) {
        controller.setIsPlaying = false;
        controller.setCurrentPosition = const Duration(seconds: 0);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              color:const Color.fromARGB(185, 80, 206, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
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
                      Null;
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
                    total: controller.getTotalDuration,
                    onSeek: (duration) {
                      double seek = duration.inMilliseconds.toDouble();
                      controller.seekDuration(seek);
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
}
