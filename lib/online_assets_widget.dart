import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'online_assets.dart';

class FutureAssetWidget extends StatelessWidget {
  const FutureAssetWidget.image({
    super.key,
    required this.assetName,
    required this.relativePath,
    this.width,
    this.height,
  }) : isImage = true;

  const FutureAssetWidget.video({
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
      child: FutureBuilder<File?>(
        future: OnlineAssets.instance.getFile(
          packName: assetName,
          relativePath: relativePath,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("snapshot.error: ${snapshot.error}");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final file = snapshot.data!;

          if (isImage) {
            return Image.file(file, width: width, height: height);
          } else {
            return PlayVideoPage(file: file);
          }
        },
      ),
    );
  }
}

class StreamAssetWidget extends StatelessWidget {
  const StreamAssetWidget.image({
    super.key,
    required this.assetName,
    required this.relativePath,
    this.width,
    this.height,
    this.isShowConfirmationDialogIcon = true,
  }) : isImage = true;

  const StreamAssetWidget.video({
    super.key,
    required this.assetName,
    required this.relativePath,
    this.isShowConfirmationDialogIcon = true,
  }) : width = null,
       height = null,
       isImage = false;

  final String assetName;
  final String relativePath;
  final double? width;
  final double? height;
  final bool isImage;
  final bool isShowConfirmationDialogIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: StreamBuilder<(File?, OnlinePack)>(
        stream: OnlineAssets.instance.streamFile(
          packName: assetName,
          relativePath: relativePath,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("snapshot.error: ${snapshot.error}");
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
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
            OnlineAssetStatus.notInstalled => Visibility.maintain(
              visible: false,
              child: const CircularProgressIndicator(),
            ),
            OnlineAssetStatus.pending => const CircularProgressIndicator(),
            OnlineAssetStatus.downloading => CircularProgressIndicator(
              value: onlinePack.progress,
            ),
            OnlineAssetStatus.completed => const Text(
              'Completed. But failed to get file',
            ),
            OnlineAssetStatus.failed => const Text(
              'Failed to download. But failed to get Error',
            ),
            OnlineAssetStatus.canceled => const Text('Canceled to download'),
            OnlineAssetStatus.unknown => const Text('Unknown Status'),
            OnlineAssetStatus.requiresUserConfirmationOnAndroid => IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: () => OnlineAssets.instance.showConfirmationDialog(),
            ),
            OnlineAssetStatus.waitingForWifiOnAndroid => Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Waiting for Wi-Fi.'),
                ValueListenableBuilder(
                  valueListenable:
                      OnlineAssets.instance.confirmationDialogShownOnAndroid,
                  builder: (context, value, child) {
                    return Visibility(visible: !value, child: child!);
                  },
                  child: IconButton(
                    icon: Icon(Icons.cloud_download),
                    onPressed:
                        () => OnlineAssets.instance.showConfirmationDialog(),
                  ),
                ),
              ],
            ),
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
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, child) {
            return FloatingActionButton(
              onPressed: () {
                setState(() {
                  value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
            );
          },
        ),
      ],
    );
  }
}
