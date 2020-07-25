import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'color_scheme.dart';

class VideoPlayer
{
  CachedVideoPlayerController controller;
  int videoLength = 0;
  double startVideoPoint = 0.0;

  String testURL = "https://firebasestorage.googleapis.com/v0/b/grading-dating-app.appspot.com/o/3bjK8bEEcYCL316lcAhZImage?alt=media&token=ad6ea8a1-6542-49d7-bbb6-74bb9a52905d";

  Future<void> setup(String videoURL) async
  {
    controller = CachedVideoPlayerController.network(videoURL);
    await controller.initialize();
    await controller.setLooping(true);
    videoLength = controller.value.duration.inSeconds;
  }

  void dispose()
  {
    controller.dispose();
  }

  Widget videoDisplay()
  {
    return Container(child: Column(children: [
      Expanded(child: CachedVideoPlayer(controller),),
      videoControls(),

    ],));
  }

  Widget videoLoading()
  {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget videoControls()
  {

    return Container(child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      playButton(),
        pauseButton(),

    ],),);
  }

  Widget playButton()
  {
    return IconButton(icon: Icon(MdiIcons.play, color: secondary, size: 36,), onPressed: play,);
  }

  Widget pauseButton()
  {
    return IconButton(icon: Icon(MdiIcons.pause, color: secondary, size: 36,), onPressed: stop,);
  }

  void play()
  {
    controller.play();
  }

  void stop()
  {
    controller.pause();
  }
}