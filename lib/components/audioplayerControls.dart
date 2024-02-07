import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/components/apis.dart';

class audioControls {
  static AudioPlayer audioPlayer = AudioPlayer();
  static PlayerState playerState = PlayerState.stopped;
  static int playingIndex = -1;
  static bool isPlaying = false;

  static Future<void> play(String url, int index) async {
    // if (index == playingIndex) {
    //   print("The playing index is $playingIndex");
    //   return;
    // }
    playingIndex = index;
    try {
      await audioPlayer.stop();
      DeviceFileSource fileSource = DeviceFileSource(url);
      print("The file source is $fileSource");
      await audioPlayer.play(fileSource);
      // .then((value) => playerState = PlayerState.playing);
    } catch (e) {
      print("The error is $e");
    }
    print("the player state is $playerState");
    print("The playing url is $url");
  }

  static Future<void> pause() async {
    await audioPlayer.pause().then((value) => playerState = PlayerState.paused);
  }

  static Future<void> stop() async {
    playingIndex = -1;
    await audioPlayer.stop().then((value) => playerState = PlayerState.stopped);
  }
}
