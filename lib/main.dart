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
      title: Text('getFile() on Files that always exist'),
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
        'streamFile() on Pack start downloading after the app is installed',
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
        'streamFile() on Pack start downloading when requested fetch',
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
      title: Text('streamFile() on Different packs'),
      subtitle: Text(
        'Android: [packName: install_time_sample_pack, .installTime]\niOS: [packName: initial_install_sample_pack, .initialInstall]',
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
            FutureAssetWidget.image(
              assetName:
                  Platform.isAndroid
                      ? 'install_time_sample_pack'
                      : 'initial_install_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_corgi_tricolor.png',
            ),
            FutureAssetWidget.image(
              assetName:
                  Platform.isAndroid
                      ? 'install_time_sample_pack'
                      : 'initial_install_sample_pack',
              relativePath:
                  'dog${Platform.pathSeparator}dog_great_pyrenees.png',
            ),
            FutureAssetWidget.image(
              assetName:
                  Platform.isAndroid
                      ? 'install_time_sample_pack'
                      : 'initial_install_sample_pack',
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
          FutureAssetWidget.video(
            assetName:
                Platform.isAndroid
                    ? 'install_time_sample_pack'
                    : 'initial_install_sample_pack',
            relativePath: 'dog${Platform.pathSeparator}movie.mp4',
          ),
        ],
      ),
    );
  }
}
