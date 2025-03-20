import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'online_assets.dart';

class StreamAssetWidget extends StatelessWidget {
  const StreamAssetWidget.image({
    super.key,
    required this.assetName,
    required this.relativePath,
    this.width,
    this.height,
  }) : isImage = true;

  const StreamAssetWidget.video({
    super.key,
    required this.assetName,
    required this.relativePath,
  }) : width = null,
       height = null,
       isImage = false;

  final String assetName;
  final String relativePath;
  final double? width;
  final double? height;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: StreamBuilder<(File?, OnlinePack)>(
        stream: OnlineAssets.instance.streamFile(
          assetName: assetName,
          relativePath: relativePath,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("snapshot.error: ${snapshot.error}");
          } else if (!snapshot.hasData) {
            return Text("snapshot.hasNotData");
          }

          final (file, onlinePack) = snapshot.data!;
          if (file != null) {
            if (isImage) {
              return Image.file(file, width: width, height: height);
            } else {
              return PlayVideoPage(file: file);
            }
          }

          if (onlinePack.hasError) {
            return switch (onlinePack) {
              AndroidPack() => Text(onlinePack.androidErrorCode.name),
              IOSPack() => Text(
                '[${onlinePack.iOSError?.domain}] ${onlinePack.iOSError?.localizedDescription}',
              ),
            };
          }

          return switch (onlinePack.status) {
            OnlineAssetStatus.pending => const Text('Pending'),
            //Todo 押下時に確認ダイアログの表示を実装
            OnlineAssetStatus.requiresUserConfirmation =>
              const CircularProgressIndicator(),
            OnlineAssetStatus.downloading => CircularProgressIndicator(
              value: onlinePack.progress,
            ),
            // Usually does not go through here.
            OnlineAssetStatus.completed => const CircularProgressIndicator(),
            OnlineAssetStatus.failed => const Text('Failed to download'),
            OnlineAssetStatus.canceled => const Text('Canceled to download'),
            OnlineAssetStatus.unknown => const Text('Unknown Status'),
          };
        },
      ),
    );
  }
}

class PlayVideoPage extends StatefulWidget {
  const PlayVideoPage({super.key, required this.file});

  final File file;

  @override
  State<PlayVideoPage> createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child:
              _controller.value.isInitialized
                  ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                  : Container(),
        ),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ],
    );
  }
}
