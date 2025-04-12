import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'online_assets.dart';

class FutureAssetWidget extends StatelessWidget {
  const FutureAssetWidget({
    super.key,
    required this.assetName,
    required this.relativePath,
    required this.fileWidgetBuilder,
    this.futureErrorBuilder = _defaultFutureErrorBuilder,
  });

  const FutureAssetWidget.image({
    super.key,
    required this.assetName,
    required this.relativePath,
    Image Function(BuildContext context, File file) imageBuilder =
        _defaultImageBuilder,
    this.futureErrorBuilder = _defaultFutureErrorBuilder,
  }) : fileWidgetBuilder = imageBuilder;

  const FutureAssetWidget.video({
    super.key,
    required this.assetName,
    required this.relativePath,
    Widget Function(BuildContext context, File file) videoBuilder =
        _defaultVideoBuilder,
    this.futureErrorBuilder = _defaultFutureErrorBuilder,
  }) : fileWidgetBuilder = videoBuilder;

  final String assetName;
  final String relativePath;

  /// If you want to pass some parameters to the widget, use this builder
  final Widget Function(BuildContext context, File file) fileWidgetBuilder;

  /// If the error is null, it is a case where File could not be retrieved and File is null.
  final Widget Function(BuildContext context, Object? error) futureErrorBuilder;

  static Image _defaultImageBuilder(BuildContext context, File file) {
    return Image.file(file);
  }

  static Widget _defaultVideoBuilder(BuildContext context, File file) {
    return PlayVideoPage(file: file);
  }

  static Widget _defaultFutureErrorBuilder(
    BuildContext context,
    Object? error,
  ) {
    if (error == null) {
      return const SizedBox.shrink();
    }

    return FittedBox(fit: BoxFit.scaleDown, child: Text("error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: OnlineAssets.instance.getFile(
        packName: assetName,
        relativePath: relativePath,
      ),
      builder: (context, snapshot) {
        final error = snapshot.error;
        final file = snapshot.data;

        if (error != null) {
          return futureErrorBuilder(context, error);
        } else if (file == null) {
          return futureErrorBuilder(context, null);
        }

        return fileWidgetBuilder(context, file);
      },
    );
  }
}

class StreamAssetWidget extends StatelessWidget {
  const StreamAssetWidget({
    super.key,
    required this.assetName,
    required this.relativePath,
    required this.fileWidgetBuilder,
    this.streamErrorBuilder = _defaultStreamErrorBuilder,
    this.onlinePackWidgetBuilder = _defaultOnlinePackWidgetBuilder,
  });

  const StreamAssetWidget.image({
    super.key,
    required this.assetName,
    required this.relativePath,
    Image Function(BuildContext context, File file) imageBuilder =
        _defaultImageBuilder,
    this.streamErrorBuilder = _defaultStreamErrorBuilder,
    this.onlinePackWidgetBuilder = _defaultOnlinePackWidgetBuilder,
  }) : fileWidgetBuilder = imageBuilder;

  const StreamAssetWidget.video({
    super.key,
    required this.assetName,
    required this.relativePath,
    Widget Function(BuildContext context, File file) videoBuilder =
        _defaultVideoBuilder,
    this.streamErrorBuilder = _defaultStreamErrorBuilder,
    this.onlinePackWidgetBuilder = _defaultOnlinePackWidgetBuilder,
  }) : fileWidgetBuilder = videoBuilder;

  final String assetName;
  final String relativePath;

  /// If you want to pass some parameters to the widget (Image), use this builder
  final Widget Function(BuildContext context, File file) fileWidgetBuilder;

  /// If the error is null, it is a case where File could not be retrieved and File is null.
  final Widget Function(BuildContext context, Object? error) streamErrorBuilder;

  /// If you want to customize widget on downloading / failed / etc, use this builder
  final Widget Function(BuildContext context, OnlinePack onlinePack)
  onlinePackWidgetBuilder;

  static Image _defaultImageBuilder(BuildContext context, File file) {
    return Image.file(file);
  }

  static Widget _defaultVideoBuilder(BuildContext context, File file) {
    return PlayVideoPage(file: file);
  }

  static Widget _defaultStreamErrorBuilder(
    BuildContext context,
    Object? error,
  ) {
    if (error == null) {
      return const SizedBox.shrink();
    }

    return FittedBox(fit: BoxFit.scaleDown, child: Text("error: $error"));
  }

  static Widget _defaultOnlinePackWidgetBuilder(
    BuildContext context,
    OnlinePack onlinePack,
  ) {
    buildIndicator({double? progress}) {
      return CircularProgressIndicator.adaptive(
        value: progress,
        constraints: BoxConstraints(
          maxWidth: 20,
          maxHeight: 20,
          minWidth: 20,
          minHeight: 20,
        ),
      );
    }

    return switch (onlinePack.status) {
      OnlineAssetStatus.notInstalled => Visibility.maintain(
        visible: false,
        child: buildIndicator(),
      ),
      OnlineAssetStatus.pending => buildIndicator(),
      OnlineAssetStatus.downloading => buildIndicator(
        progress: onlinePack.progress,
      ),
      OnlineAssetStatus.completed => FittedBox(
        fit: BoxFit.scaleDown,
        child: const Text('Completed. But failed to get file'),
      ),
      OnlineAssetStatus.failed => FittedBox(
        fit: BoxFit.scaleDown,
        child: const Text('Failed to download. But failed to get Error'),
      ),
      OnlineAssetStatus.canceled => FittedBox(
        child: const Text('Canceled to download'),
      ),
      OnlineAssetStatus.unknown => FittedBox(
        fit: BoxFit.scaleDown,
        child: const Text('Unknown Status'),
      ),
      OnlineAssetStatus.requiresUserConfirmationOnAndroid =>
        ValueListenableBuilder(
          valueListenable: OnlineAssets.instance.confirmationDialogResult,
          builder: (context, result, child) {
            return switch (result) {
              null || false => InkWell(
                child: Icon(Icons.cloud_download),
                onTap: () => OnlineAssets.instance.showConfirmationDialog(),
              ),
              true => buildIndicator(),
            };
          },
        ),
      OnlineAssetStatus.waitingForWifiOnAndroid => Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Waiting for Wi-Fi.'),
          IconButton(
            icon: Icon(Icons.cloud_download),
            onPressed: () => OnlineAssets.instance.showConfirmationDialog(),
          ),
        ],
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<(File?, OnlinePack)>(
      stream: OnlineAssets.instance.streamFile(
        packName: assetName,
        relativePath: relativePath,
      ),
      builder: (context, snapshot) {
        final error = snapshot.error;
        final data = snapshot.data;

        if (error != null) {
          return streamErrorBuilder(context, error);
        } else if (data == null) {
          return streamErrorBuilder(context, null);
        }
        final (file, onlinePack) = data;

        if (file != null) {
          return fileWidgetBuilder(context, file);
        }

        return onlinePackWidgetBuilder(context, onlinePack);
      },
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
