// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:thefuture/globals.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatelessWidget {
  String inputURL = '';
  VideoView({Key? key, required this.inputURL}) : super(key: key);
  late YoutubePlayerController _controller;
  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(inputURL)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    return Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          leading: Container(),
          toolbarHeight: 1,
          elevation: 0,
        ),
        body: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              // _controller.addListener(listener);
            },
          ),
        ));
  }
}
