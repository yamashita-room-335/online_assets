import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_assets/online_assets.dart';
import 'package:online_assets/play_asset_delivery.g.dart';

import 'online_assets_widget.dart';

// In the sample app, the enum is not created for the sake of clarity,
// but if you create it in this way, you can avoid specifying the wrong packName.
/*
enum MyAndroidAssetPack {
  installTimeSamplePack(
    packName: 'install_time_sample_pack',
    deliveryMode: AndroidAssetPackDeliveryMode.installTime,
  ),
  fastFollowSamplePack(
    packName: 'fast_follow_sample_pack',
    deliveryMode: AndroidAssetPackDeliveryMode.fastFollow,
  ),
  onDemandSamplePack(
    packName: 'on_demand_sample_pack',
    deliveryMode: AndroidAssetPackDeliveryMode.onDemand,
  );

  const MyAndroidAssetPack({
    required this.packName,
    required this.deliveryMode,
  });

  final String packName;
  final AndroidAssetPackDeliveryMode deliveryMode;
}

enum MyIOSAssetTag {
  installTimeSamplePack(
    tag: '',
    odrType: IOSOnDemandResourceType.assetsWithoutTag,
  ),
  initialInstallSamplePack(
    tag: 'initial_install_sample_pack',
    odrType: IOSOnDemandResourceType.initialInstall,
  ),
  fastFollowSamplePack(
    tag: 'fast_follow_sample_pack',
    odrType: IOSOnDemandResourceType.prefetch,
  ),
  onDemandSamplePack(
    tag: 'on_demand_sample_pack',
    odrType: IOSOnDemandResourceType.onDemand,
  );

  const MyIOSAssetTag({required this.tag, required this.odrType});

  final String tag;
  final IOSOnDemandResourceType odrType;
}

// Create an integrated Enum for easy handling of different tags and asset pack names
enum MyAssets {
  installTimeSamplePack(
    android: MyAndroidAssetPack.installTimeSamplePack,
    ios: MyIOSAssetTag.installTimeSamplePack,
  ),
  initialInstallSamplePack(
    android: MyAndroidAssetPack.installTimeSamplePack,
    ios: MyIOSAssetTag.initialInstallSamplePack,
  ),
  fastFollowSamplePack(
    android: MyAndroidAssetPack.fastFollowSamplePack,
    ios: MyIOSAssetTag.fastFollowSamplePack,
  ),
  onDemandSamplePack(
    android: MyAndroidAssetPack.onDemandSamplePack,
    ios: MyIOSAssetTag.onDemandSamplePack,
  );

  const MyAssets({required this.android, required this.ios});

  final MyAndroidAssetPack android;
  final MyIOSAssetTag ios;

  String get packName => Platform.isAndroid ? android.packName : ios.tag;
}

void main() {
  // ...
  OnlineAssets.instance.init(
    androidPackSettingsList:
        MyAndroidAssetPack.values
            .map(
              (e) => AndroidPackSettings(
                packName: e.packName,
                deliveryMode: e.deliveryMode,
              ),
            )
            .toList(),
    iosPackSettingsList:
        MyIOSAssetTag.values
            .map((e) => IOSPackSettings(packName: e.tag, odrType: e.odrType))
            .toList(),
  );
  // ...
}
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PlayAssetDeliveryFlutterApi.setUp(PlayAssetDeliveryFlutterApiWrapper());

  OnlineAssets.instance.init(
    androidPackSettingsList: [
      AndroidPackSettings(
        packName: 'install_time_sample_pack',
        deliveryMode: AndroidAssetPackDeliveryMode.installTime,
      ),
      AndroidPackSettings(
        packName: 'fast_follow_sample_pack',
        deliveryMode: AndroidAssetPackDeliveryMode.fastFollow,
      ),
      AndroidPackSettings(
        packName: 'on_demand_sample_pack',
        deliveryMode: AndroidAssetPackDeliveryMode.onDemand,
      ),
    ],
    iosPackSettingsList: [
      IOSPackSettings(
        packName: '',
        odrType: IOSOnDemandResourceType.assetsWithoutTag,
      ),
      IOSPackSettings(
        packName: 'initial_install_sample_pack',
        odrType: IOSOnDemandResourceType.initialInstall,
      ),
      IOSPackSettings(
        packName: 'fast_follow_sample_pack',
        odrType: IOSOnDemandResourceType.prefetch,
      ),
      IOSPackSettings(
        packName: 'on_demand_sample_pack',
        odrType: IOSOnDemandResourceType.onDemand,
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
                  MustExistPackFutureImagePage.buildDescription(),
                  ElevatedButton(
                    child: Text('Image'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MustExistPackFutureImagePage(),
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
                          builder: (context) => MustExistPackFutureVideoPage(),
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
              Divider(),
              ElevatedButton(
                child: Text('Delete copied asset'),
                onPressed: () {
                  OnlineAssets.instance.deleteCopiedAssetFile(relativePath: "");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MustExistPackFutureImagePage extends StatelessWidget {
  const MustExistPackFutureImagePage({super.key});

  static buildDescription() {
    return ListTile(
      title: Text(
        'Example of using OnlineAssets.instance.getFile() in asset pack where the file always exists (unless an exception is raised), and using different pack names across platforms.',
      ),
      subtitle: Text(
        'Android: [packName: "install_time_sample_pack", .installTime]\niOS: [packName: "", .assetsWithoutTag]',
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
            MustExistPackFutureImagePage.buildDescription(),
            Divider(),
            FutureAssetWidget.image(
              assetName: Platform.isAndroid ? 'install_time_sample_pack' : '',
              relativePath: 'install_time_sample_pack/dog/image.png',
            ),
            FutureAssetWidget.image(
              assetName: Platform.isAndroid ? 'install_time_sample_pack' : '',
              relativePath: 'install_time_sample_pack/dog_image.png',
            ),
          ],
        ),
      ),
    );
  }
}

class MustExistPackFutureVideoPage extends StatelessWidget {
  const MustExistPackFutureVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          MustExistPackFutureImagePage.buildDescription(),
          Divider(),
          FutureAssetWidget.video(
            assetName: Platform.isAndroid ? 'install_time_sample_pack' : '',
            relativePath: 'install_time_sample_pack/dog/movie.mp4',
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
        'Android: [packName: "fast_follow_sample_pack", .fastFollow]\niOS: [packName: "fast_follow_sample_pack", .prefetch]',
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
              relativePath: 'fast_follow_sample_pack/dog/image.png',
            ),
            StreamAssetWidget.image(
              assetName: 'fast_follow_sample_pack',
              relativePath: 'fast_follow_sample_pack/dog_image.png',
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
            relativePath: 'fast_follow_sample_pack/dog/movie.mp4',
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
        'Android: [packName: "on_demand_sample_pack", .onDemand]\niOS: [packName: "on_demand_sample_pack", .onDemand]',
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
              relativePath: 'on_demand_sample_pack/dog/image.png',
            ),
            StreamAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath: 'on_demand_sample_pack/dog_image.png',
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
            relativePath: 'on_demand_sample_pack/dog/movie.mp4',
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
        'Android: [packName: "on_demand_sample_pack", .onDemand]\niOS: [packName: "on_demand_sample_pack", .onDemand]',
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
              stream: OnlineAssets.instance.stream(
                packName: 'on_demand_sample_pack',
              ),
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
        'Android: [packName: "on_demand_sample_pack", .onDemand]\niOS: [packName: "on_demand_sample_pack", .onDemand]',
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
            FutureImagePage.buildDescription(),
            Divider(),
            FutureAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath: 'on_demand_sample_pack/dog/image.png',
            ),
            FutureAssetWidget.image(
              assetName: 'on_demand_sample_pack',
              relativePath: 'on_demand_sample_pack/dog_image.png',
            ),
          ],
        ),
      ),
    );
  }
}
