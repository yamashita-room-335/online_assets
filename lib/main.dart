import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_assets/online_assets.dart';

import 'online_assets_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OnlineAssets.instance.init(
    assetPackSettingsList: [
      OnlineAssetPackSettings(
        packName: 'install_time_sample_pack',
        isInstallTimeAssetPack: true,
      ),
      OnlineAssetPackSettings(
        packName: 'fast_follow_sample_pack',
        isInstallTimeAssetPack: false,
      ),
      OnlineAssetPackSettings(
        packName: 'on_demand_sample_pack',
        isInstallTimeAssetPack: false,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                ListTile(title: Text('Install Time Sample Pack')),
                ElevatedButton(
                  child: Text('Future Image'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstallTimeFutureImagePage(),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Future Video'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstallTimeFutureVideoPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Divider(),
            Column(
              children: [
                ListTile(title: Text('Fast Follow (on Android) Sample Pack')),
                ElevatedButton(
                  child: Text('Stream Image'),
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
                  child: Text('Stream Video'),
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
                ListTile(title: Text('On Demand (on Android) Sample Pack')),
                ElevatedButton(
                  child: Text('Stream Image'),
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
                  child: Text('Stream Video'),
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
          ],
        ),
      ),
    );
  }
}

class InstallTimeFutureImagePage extends StatelessWidget {
  const InstallTimeFutureImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Future Image Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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

class InstallTimeFutureVideoPage extends StatelessWidget {
  const InstallTimeFutureVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Future Image Page')),
      body: FutureAssetWidget.video(
        assetName: 'install_time_sample_pack',
        relativePath: 'dog${Platform.pathSeparator}movie.mp4',
      ),
    );
  }
}

class FastFollowStreamImagePage extends StatelessWidget {
  const FastFollowStreamImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream Image Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
      appBar: AppBar(title: Text('Stream Image Page')),
      body: StreamAssetWidget.video(
        assetName: 'fast_follow_sample_pack',
        relativePath: 'dog${Platform.pathSeparator}movie.mp4',
      ),
    );
  }
}

class OnDemandStreamImagePage extends StatelessWidget {
  const OnDemandStreamImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream Image Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
      appBar: AppBar(title: Text('Stream Image Page')),
      body: StreamAssetWidget.video(
        assetName: 'on_demand_sample_pack',
        relativePath: 'dog${Platform.pathSeparator}movie.mp4',
      ),
    );
  }
}
