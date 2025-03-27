import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_assets/online_assets.dart';
import 'package:online_assets/play_asset_delivery.g.dart';

import 'online_assets_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PlayAssetDeliveryFlutterApi.setUp(PlayAssetDeliveryFlutterApiWrapper());

  OnlineAssets.instance.init(
    assetPackSettingsList: [
      OnlineAssetPackSettings(
        packName: 'install_time_sample_pack',
        androidAssetPackDeliveryMode: AndroidAssetPackDeliveryMode.installTime,
        iosOnDemandResourceType: IOSOnDemandResourceType.assetsWithoutTag,
      ),
      OnlineAssetPackSettings(
        packName: 'initial_install_sample_pack',
        androidAssetPackDeliveryMode: null,
        iosOnDemandResourceType: IOSOnDemandResourceType.initialInstall,
      ),
      OnlineAssetPackSettings(
        packName: 'fast_follow_sample_pack',
        androidAssetPackDeliveryMode: AndroidAssetPackDeliveryMode.fastFollow,
        iosOnDemandResourceType: IOSOnDemandResourceType.prefetch,
      ),
      OnlineAssetPackSettings(
        packName: 'on_demand_sample_pack',
        androidAssetPackDeliveryMode: AndroidAssetPackDeliveryMode.onDemand,
        iosOnDemandResourceType: IOSOnDemandResourceType.onDemand,
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Online Assets', home: const MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sample Usage')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'This app works with "Google Play Console"\'s internal testing and "App Store Connect"\'s TestFlight, but some features may not work in other ways.\nSee the README if app does not work correctly.',
              ),
              Divider(),
              Column(
                children: [
                  InstallTimePackFutureImagePage.buildDescription(),
                  ElevatedButton(
                    child: Text('Image'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => InstallTimePackFutureImagePage(),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Video'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => InstallTimePackFutureVideoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  FastFollowStreamImagePage.buildDescription(),
                  ElevatedButton(
                    child: Text('Image'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FastFollowStreamImagePage(),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Video'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FastFollowStreamVideoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  OnDemandStreamImagePage.buildDescription(),
                  ElevatedButton(
                    child: Text('Image'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnDemandStreamImagePage(),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Video'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnDemandStreamVideoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  DifferentPacksStreamImagePage.buildDescription(),
                  ElevatedButton(
                    child: Text('Image'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DifferentPacksStreamImagePage(),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Video'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DifferentPacksStreamVideoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  DownloadGuardImagePage.buildDescription(),
                  ElevatedButton(
                    child: Text('Image'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DownloadGuardImagePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InstallTimePackFutureImagePage extends StatelessWidget {
  const InstallTimePackFutureImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text(
        'Example of using OnlineAssets.instance.getFile() in asset pack where the file always exists (unless an exception is raised).',
      ),
      subtitle: Text(
        'Android: [packName: install_time_sample_pack, .installTime]\niOS: [packName: install_time_sample_pack, .assetsWithoutTag]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InstallTimePackFutureImagePage.buildDescription(),
            Divider(),
            FutureAssetWidget.image(
              assetName: 'install_time_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_corgi_tricolor.png',
            ),
            FutureAssetWidget.image(
              assetName: 'install_time_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_great_pyrenees.png',
            ),
            FutureAssetWidget.image(
              assetName: 'install_time_sample_pack',
              relativePath: 'dog_shetland_sheepdog_blue_merle.png',
            ),
          ],
        ),
      ),
    );
  }
}

class InstallTimePackFutureVideoPage extends StatelessWidget {
  const InstallTimePackFutureVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          InstallTimePackFutureImagePage.buildDescription(),
          Divider(),
          FutureAssetWidget.video(
            assetName: 'install_time_sample_pack',
            relativePath: 'dog${Platform.pathSeparator}movie.mp4',
          ),
        ],
      ),
    );
  }
}

class FastFollowStreamImagePage extends StatelessWidget {
  const FastFollowStreamImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text(
        'Example of using OnlineAssets.instance.streamFile() with a pack that is downloaded promptly after installation.\n⚠️Prefetch assets in iOS do not start downloading when the installation is complete with the Run button in Xcode, but work the same way as On Demand. Only in TestFlight and production environments will downloading begin after installation is complete.',
      ),
      subtitle: Text(
        'Android: [packName: fast_follow_sample_pack, .fastFollow]\niOS: [packName: fast_follow_sample_pack, .prefetch]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FastFollowStreamImagePage.buildDescription(),
            Divider(),
            StreamAssetWidget.image(
              assetName: 'fast_follow_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_corgi_tricolor.png',
            ),
            StreamAssetWidget.image(
              assetName: 'fast_follow_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_great_pyrenees.png',
            ),
            StreamAssetWidget.image(
              assetName: 'fast_follow_sample_pack',
              relativePath: 'dog_shetland_sheepdog_blue_merle.png',
            ),
          ],
        ),
      ),
    );
  }
}

class FastFollowStreamVideoPage extends StatelessWidget {
  const FastFollowStreamVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FastFollowStreamImagePage.buildDescription(),
          Divider(),
          StreamAssetWidget.video(
            assetName: 'fast_follow_sample_pack',
            relativePath: 'dog${Platform.pathSeparator}movie.mp4',
          ),
        ],
      ),
    );
  }
}

class OnDemandStreamImagePage extends StatelessWidget {
  const OnDemandStreamImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text(
        'Example of using OnlineAssets.instance.streamFile() with an on-demand pack. Download is started when OnlineAssets.instance.streamFile() is used',
      ),
      subtitle: Text(
        'Android: [packName: on_demand_sample_pack, .onDemand]\niOS: [packName: on_demand_sample_pack, .onDemand]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OnDemandStreamImagePage.buildDescription(),
            Divider(),
            StreamAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_corgi_tricolor.png',
            ),
            StreamAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_great_pyrenees.png',
            ),
            StreamAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath: 'dog_shetland_sheepdog_blue_merle.png',
            ),
          ],
        ),
      ),
    );
  }
}

class OnDemandStreamVideoPage extends StatelessWidget {
  const OnDemandStreamVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          OnDemandStreamImagePage.buildDescription(),
          Divider(),
          StreamAssetWidget.video(
            assetName: 'on_demand_sample_pack',
            relativePath: 'dog${Platform.pathSeparator}movie.mp4',
          ),
        ],
      ),
    );
  }
}

class DifferentPacksStreamImagePage extends StatelessWidget {
  const DifferentPacksStreamImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text('Example of using different pack names across platforms.'),
      subtitle: Text(
        'Android: [packName: install_time_sample_pack, .installTime]\niOS: [packName: fast_follow_sample_pack, .prefetch]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DifferentPacksStreamImagePage.buildDescription(),
            Divider(),
            StreamAssetWidget.image(
              assetName:
                  Platform.isAndroid
                      ? 'install_time_sample_pack'
                      : 'fast_follow_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_corgi_tricolor.png',
            ),
            StreamAssetWidget.image(
              assetName:
                  Platform.isAndroid
                      ? 'install_time_sample_pack'
                      : 'fast_follow_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_great_pyrenees.png',
            ),
            StreamAssetWidget.image(
              assetName:
                  Platform.isAndroid
                      ? 'install_time_sample_pack'
                      : 'fast_follow_sample_pack',
              relativePath: 'dog_shetland_sheepdog_blue_merle.png',
            ),
          ],
        ),
      ),
    );
  }
}

class DifferentPacksStreamVideoPage extends StatelessWidget {
  const DifferentPacksStreamVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          DifferentPacksStreamImagePage.buildDescription(),
          Divider(),
          StreamAssetWidget.video(
            assetName:
                Platform.isAndroid
                    ? 'install_time_sample_pack'
                    : 'fast_follow_sample_pack',
            relativePath: 'dog${Platform.pathSeparator}movie.mp4',
          ),
        ],
      ),
    );
  }
}

class DownloadGuardImagePage extends StatelessWidget {
  const DownloadGuardImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text(
        'Example with a mechanism that monitors the status of the pack and allows transition to the screen to use the asset if the download is complete.',
      ),
      subtitle: Text(
        'Android: [packName: on_demand_sample_pack, .onDemand]\niOS: [packName: on_demand_sample_pack, .onDemand]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DownloadGuardImagePage.buildDescription(),
            Divider(),
            StreamBuilder(
              stream:
                  OnlineAssets
                      .instance
                      .onlinePackSubjectMap['on_demand_sample_pack']!,
              builder: (
                BuildContext context,
                AsyncSnapshot<OnlinePack> snapshot,
              ) {
                final downloadButton = IconButton(
                  icon: Icon(Icons.cloud_download),
                  onPressed:
                      () => OnlineAssets.instance.fetch([
                        'on_demand_sample_pack',
                      ]),
                );

                if (snapshot.hasError) {
                  return Column(
                    children: [
                      Text("snapshot.error: ${snapshot.error}"),
                      downloadButton,
                    ],
                  );
                } else if (!snapshot.hasData) {
                  return downloadButton;
                }

                final onlinePack = snapshot.data!;
                return Column(
                  children: [
                    Text('on_demand_sample_pack: ${onlinePack.status}'),
                    LinearProgressIndicator(value: onlinePack.progress),
                    switch (onlinePack.status) {
                      OnlineAssetStatus.waitingForWifiOnAndroid ||
                      OnlineAssetStatus
                          .requiresUserConfirmationOnAndroid => IconButton(
                        icon: Icon(Icons.cloud_download),
                        onPressed:
                            () =>
                                OnlineAssets.instance.showConfirmationDialog(),
                      ),
                      OnlineAssetStatus.failed ||
                      OnlineAssetStatus.notInstalled ||
                      OnlineAssetStatus.canceled ||
                      OnlineAssetStatus.unknown => downloadButton,
                      OnlineAssetStatus.pending ||
                      OnlineAssetStatus.downloading => SizedBox.shrink(),
                      OnlineAssetStatus.completed => TextButton(
                        child: Text('Next Page where the file exists'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //
                              builder: (context) => FutureImagePage(),
                            ),
                          );
                        },
                      ),
                    },
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FutureImagePage extends StatelessWidget {
  const FutureImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text('getFile() on Files exists with high probability'),
      subtitle: Text(
        'Android: [packName: on_demand_sample_pack, .onDemand]\niOS: [packName: on_demand_sample_pack, .onDemand]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InstallTimePackFutureImagePage.buildDescription(),
            Divider(),
            FutureAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_corgi_tricolor.png',
            ),
            FutureAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_great_pyrenees.png',
            ),
            FutureAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath: 'dog_shetland_sheepdog_blue_merle.png',
            ),
          ],
        ),
      ),
    );
  }
}
