import 'package:flutter/material.dart';
import 'package:online_assets/online_assets.dart';

import 'online_assets_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OnlineAssets.instance.init(['install_time_sample_pack']);

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
      body: Column(
        children: [
          ElevatedButton(
            child: Text('Stream Image'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StreamImagePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StreamImagePage extends StatelessWidget {
  const StreamImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream Image Page')),
      body: Column(
        children: [
          OnlineAssetWidget.image(
            assetName: 'install_time_sample_pack',
            relativePath: 'dog/dog_corgi_tricolor.png',
          ),
          OnlineAssetWidget.image(
            assetName: 'install_time_sample_pack',
            relativePath: 'dog/dog_great_pyrenees.png',
          ),
          OnlineAssetWidget.image(
            assetName: 'install_time_sample_pack',
            relativePath: 'dog_shetland_sheepdog_blue_merle.png',
          ),
        ],
      ),
    );
  }
}
