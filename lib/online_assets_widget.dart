import 'dart:io';

import 'package:flutter/material.dart';

import 'online_assets.dart';

class StreamAssetWidget extends StatelessWidget {
  const StreamAssetWidget.image({
    super.key,
    required this.assetName,
    required this.relativePath,
    this.width,
    this.height,
  });

  final String assetName;
  final String relativePath;
  final double? width;
  final double? height;

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
          if (snapshot.hasData) {
            final (file, onlinePack) = snapshot.data!;
            if (file != null) {
              return Image.file(file, width: width, height: height);
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
              OnlineAssetStatus.pending => const SizedBox(),
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
          }
          return const SizedBox();
        },
      ),
    );
  }
}
