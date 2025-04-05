# Readmeの言語

[English](README.md) | [日本語](README.ja.md)

# online_assets

## はじめに

Play Asset Delivery（Android）とOn-Demand Resources（iOS）の機能を統合したFlutterのサンプルアプリです。

ライセンスはMITなので、個々人でカスタマイズしたり、ライブラリ化しても構いません。

## 使い方の簡単な説明

1. Play Asset Delivery（Android）とOn-Demand Resources（iOS）の機能に従いアセットを設置します。

2. `OnlineAssets.instance.init()`を呼び出して、アセットパックの名前と種類を伝えます。

    ```dart
    void main() {
      // ...
      OnlineAssets.instance.init(
        androidPackSettingsList: [
          // ...
          AndroidPackSettings(
            packName: 'on_demand_sample_pack',
            deliveryMode: AndroidAssetPackDeliveryMode.onDemand,
          ),
          // ...
        ],
        iosPackSettingsList: [
          // ...
          IOSPackSettings(
            packName: 'on_demand_sample_pack',
            odrType: IOSOnDemandResourceType.onDemand,
          ),
          // ...
        ],
      );
      // ...
      runApp(const MyApp());
    }
    ```

3. `OnlineAssets.instance.streamFile()`を呼び出せば、アセットのダウンロードが開始され、アセットの状態やダウンロード後のファイルを取得できます。

    ```dart
    StreamBuilder<(File?, OnlinePack)>(
      stream: OnlineAssets.instance.streamFile(
        packName:'on_demand_sample_pack',
        relativePath: 'on_demand_sample_pack/dog/image.png',
      ),
      // ...
    )
    ```

基本的な使い方はこれだけです！
他にもいろいろな機能が存在します。

- `OnlineAssets.instance.fetch()`を呼び出せば、アセットのダウンロードが行えます。

    ```dart
    OnlineAssets.instance.fetch([
      'on_demand_sample_pack',
    ])
    ```

- `OnlineAssets.instance.stream()`を呼び出せば、パックのダウンロード状況の確認もできます。

    ```dart
    StreamBuilder(
      stream: OnlineAssets.instance.stream(
        packName: 'on_demand_sample_pack',
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<OnlinePack> snapshot,
      ) {
        // ...
        final onlinePack = snapshot.data!;
        // ...
      }
    ```

- 「Androidのinstall-timeアセットパックを使用している」、「iOSのInitial install tagsのアセットを使用している」、「前の画面でダウンロード済みなことを確認している」など、ファイルが高い確率で存在していると分かっている場合は`OnlineAssets.instance.getFile()`で呼び出すこともできます。

    ```dart
    FutureBuilder<File?>(
      future: OnlineAssets.instance.getFile(
        packName: assetName,
        relativePath: relativePath,
      ),
      // ...
    )
    ```

    ただし、取得できなかった場合はnullが返ってきます。
    
    そのため、これを使用するページではパックの状態を監視して問題があれば別ページへ遷移させたり、表示されなくても問題ないUIとしたりするなどの工夫が必要です。


## iOSテストの注意点

Android Studioの実行ボタンやflutter runでは、On-Demand Resourcesを取得することはできません。
XcodeのRunボタンで実行すれば、On-Demand Resources機能の確認はできますが、アプリインストール時に付属してくるリソースが存在しないという制限が存在するため、以下の点に気をつける必要があります。

- Initial install tagsのリソースは、インストール時に存在せず、ダウンロードすることもできないため、動作確認できない。
- Prefetch tag orderのリソースは、インストール後に自動でダウンロードされず、ダウンロードを呼び出す必要があるため、On-Demandと同じような動作確認しかできない。

アプリをApp Store ConnectにデリバリしてTestFlight経由でテストすると、正常に動作します。
そのため、実装初期はInitial install tags以外を使用して、TestFlightでリソースの種類を切り替える必要があります。

## Androidテストの注意点

Android Studioの実行ボタンflutter runでは、Asset Packを取得することはできません。
BundleToolを使用すれば、Play Asset Delivery機能を確認できますが、全Asset Packが端末にインストールされるためダウンロードできる正常系しか確認できないという制限があります。

アプリをGoogle Play Consoleに設置して内部テスト経由でテストすると、正常に動作します。
そのため、実装初期はBundleToolを使用してテストし、Google Play Consoleではエラー系をテストしてください。

1. [BundleTool](https://github.com/google/bundletool/releases)をダウンロードします。

2. アプリをビルドします。

    ```bash
    flutter build appbundle
    ```

3. 以下のコマンドを実行します。 (もちろん、パスやファイル名は変更できます）

    ```bash
    java -jar bundletool-all-1.18.1.jar build-apks --overwrite --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/app/outputs/bundle/release/app-release-pad-test.apks --local-testing
    ```

    ```bash
    java -jar bundletool-all-1.18.1.jar install-apks --apks=build/app/outputs/bundle/release/app-release-pad-test.apks
    ```

- 必要に応じて以下のコマンドで情報を確認できます。

    - 最終的なAPKサイズの確認

        ```bash
        java -jar bundletool-all-1.18.1.jar get-size total --apks=build/app/outputs/bundle/release/app-release-pad-test.apks --dimensions=SDK
        ```

### Details
- [アセット配信を統合する（Kotlin および Java）  |  Google Play  |  Android Developers](https://developer.android.com/guide/playcore/asset-delivery/integrate-java?hl=ja)
- [アセット配信をテストする  |  Google Play  |  Android Developers](https://developer.android.com/guide/playcore/asset-delivery/test?hl=ja)

---

# サンプルアプリの実装説明

あなたのアプリに実装を取り入れられるように、このサンプルアプリの実装の仕組みを説明します。

最初にコミットしたファイルは、Android Studioの「New Project」で作成したものです。

そのため、サンプルアプリの実装で追加された内容は、最初のコミットと最新コミットの差分ファイルで確認できます。

もしFlutterや各プラグインが古くなっても、この実装を理解して、新しくFlutterプロジェクトを作成して差分ファイルを移植すれば、動作させられると思います。

## 対応プラットフォーム

このサンプルアプリの実装はAndroidとiOSの両方に対応していますが、他のプラットフォームには対応していません。

そのため、他のプラットフォームも実装しているアプリに機能を組み込むためには、Gitの別ブランチなどで対応する必要があります。

例えば、mainブランチではFlutterのアセットを使用する実装のままとして、この機能（Android & iOS）のブランチではFlutterのアセットから各プラットフォームのアセットへ移動しておく、などの運用です。

おそらく、Flavorでも管理できますが、作者は試していないため、想定していない問題が発生するかもしれません。

## Play Asset Delivery (Android)

### AssetとGradle設定のセットアップ

[Android developers site](https://developer.android.com/guide/playcore/asset-delivery/integrate-java#build_for_kotlin_and_java)を参考に、Android側にアセットとGradleの設定を追加しました。

2025年3月23日現在、各アセットパックのAndroidManifest.xmlはGradleビルド時に生成されると記載されていますが、Flutter 3.29.2では自動生成されません。

そのため、純粋なAndroidアプリを作成してGradleビルドを行いAndroidManifest.xmlを確認したり、[別の機能のAndroidManifest.xmlの記述](https://developer.android.com/guide/playcore/feature-delivery/instant)を確認して、各アセットパックのAndroidManifest.xmlを作成しました。

### AndroidのAsset仕様に関するメモ

#### Androidのアセットパックの名前空間について

別々のアセットパックで同じ相対パスのファイルを設置することは可能ですが、それはファイルの中身も同じものである必要があります。

例えば、以下のようにアセットを設置するとします。

* android/install_time_sample_pack/src/main/assets/dog/image.png
* android/on_demand_sample_pack/src/main/assets/dog/image.png

もしimage.pngが同じ画像ファイルであればビルドは成功しますが、異なる画像ファイルの場合は以下のビルドエラーが発生します。

```bash
FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:packageReleaseBundle'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.PackageBundleTask$BundleToolWorkAction
   > Modules 'install_time_sample_pack' and 'on_demand_sample_pack' contain entry 'assets/dog/image.png' with different content.
```

そのため、このサンプルアプリのようにassetsフォルダ以下にパック名のフォルダを作成しておく方が安全でしょう。

*　android/install_time_sample_pack/src/main/assets/install_time_sample_pack/dog/image.png
*　android/on_demand_sample_pack/src/main/assets/on_demand_sample_pack/dog/image.png

#### Androidのアセットパックの制限について

[Play Console Help](https://support.google.com/googleplay/android-developer/answer/9859372?hl=ja#size_limits)に制限の記載があります。

- 個別のアセットパックのサイズ制限: 1.5GB
- 全モジュールとinstall-timeアセットパックの累計のサイズ制限: 4GB
- on-demandとfast-followアセットパックの累計のサイズ制限: 4GB
- アセットパックの最大数: 100

もしサイズ制限を考慮しなければならないほど、アプリサイズが今後大きくなりうる場合は、 大まかな機能毎にアセットパックを分けておくことを推奨します。

後述のOn-Demand Resourcesの種類や制限も把握して、どのようにアセットパックを分けるか考えてください。

#### AndroidのAssetの解像度について

FlutterのAssetやAndroidのResourcesとは異なり、AndroidのAssetにはデバイスの解像度ごとに呼び出すファイルを切り替える仕組みはありません。

そのため、このサンプルアプリでも解像度は1種類しか設置していません。

もしそのような機能を使いたい場合は、アプリ側で端末解像度毎に呼び出すアセットパック（もしくは同一アセットパックの端末解像度毎のファイル）を切り替える実装が必要になります。

※この機能のプルリクエストは大歓迎です。

端末解像度毎のアセットパックとする場合は、 使用しない解像度のファイルがダウンロードされないためアプリ容量を削減できるというメリットがあります。
ただし、アセットパックの上限数が100個のため、"解像度5種類"として考えると、アプリの機能毎にパックを分割する場合は簡単にパック数上限に到達してしまうデメリットがあります。

同一アセットパックで端末サイズ毎のファイルとする場合は、パック数上限に到達しにくいため機能毎のパックとして配信できるメリットがあります。
ただし、使用しない端末解像度のファイルまでダウンロードされてしまいます。

あなたのアプリでユーザーがどの機能をどの割合で使用するかを意識して、どちらか適切な方を選んでください。

### Add Proguard workaround
Flutter 3.29.2では、アセットパックを追加してリリースビルド(`flutter build appbundle`)を行うと以下のエラーが発生します。

```bash
ERROR: Missing classes detected while running R8. Please add the missing classes or apply additional keep rules that are generated in C:\src\online_assets\build\app\outputs\mapping\release\missing_rules.txt.
ERROR: R8: Missing class com.google.android.gms.common.annotation.NoNullnessRewrite (referenced from: void com.google.android.play.core.ktx.zzn.onSuccess(java.lang.Object))

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:minifyReleaseWithR8'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.R8Task$R8Runnable
   > Compilation failed to complete
```

適切な対処方法が分からないので、これを回避するために以下のように`dontwarn`を追加しました。

* `android/app/build.gradle.kts`

    ```android/app/build.gradle.kts
    android {
        // ...
        buildTypes {
            release {
                // ...
                proguardFiles(
                    "proguard-rules.pro"
                )
            }
        }
    }
    ```

* `android/app/proguard-rules.pro`

    ```android/app/proguard-rules.pro
    -dontwarn com.google.android.gms.common.annotation.NoNullnessRewrite
    ```

もし適切な対処法をご存知でしたら、Issueかプルリクエストを送信してください。

AndroidでPlay Asset Deliveryを使用するために必要なものは以上で、残りは『Flutter関連実装』で後述します。

## On-Demand Resources (iOS)

### AssetとOn-Demand Resources Tags設定のセットアップ

ios/Runner.xcworkspaceをXcodeで開き、`Assets`へアセットファイルを追加しました。

アセットパック間でパス名が衝突しないように、以下のルールで格納しています。

- [Android側の各アセットパックのassetsフォルダ内のフォルダ（またはファイル）]をXcode上の`Assets`にドラッグ＆ドロップします。

- 一番上のフォルダ（またはファイル）には、`On-Demand Resource Tags`: [アセットパック名]を設定します。

  親フォルダの`On-Demand Resource Tags`は自動で継承されるため、内側のフォルダに設定する必要はありません。

  （むしろ個別で設定すると別のアセットパックへ移動する際に更新忘れが発生するため、避けることが望ましいです）

- 全てのフォルダに「`Provides Namespace`: 有効」を設定して、Androidと同じパスになるようにします。

  これは親フォルダだけでなく内側のフォルダにも設定する必要があります。

例）
- Android

    - パス: `android/install_time_sample_pack/src/main/assets/install_time_sample_pack/dog_image.png`

- iOS側

   - Xcodeでの表示パス: `install_time_sample_pack/dog_image` 

- Flutter呼び出し（詳細は後述）

    ```.dart
    OnlineAssets.instance.streamFile(
      packName: 'install_time_sample_pack',
      relativePath: 'install_time_sample_pack/dog_image.png',
    )
    ```

[On-Demand Resources Guide](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/Tagging.html#//apple_ref/doc/uid/TP40015083-CH3-SW1)にOn-Demand Resources Tagsの種類と設定方法の記載があります。

- `Initial install tags`: リソースはアプリと同時にダウンロードされます。ただし、削除可能なので使用前には存在するかどうかの確認が必要になります。
- `Prefetch tag order`: アプリのインストール後にダウンロードが開始されます。
- `Dowloaded only on demand`: リクエストした時にダウンロードされます。

上記ページに従って、各タグを振り分けます。

上記のいずれもリソースが存在するかどうかの確認が必要なため、Androidのinstall-timeのように確実に存在する仕組みはOn-Demand Resourcesにはありませんでした。

そのため、このサンプルアプリでは上記3つに加えて、On-Demand Resource Tagsを設定しない純粋なiOSのアセットも使用できるようにしています。（`IOSOnDemandResourceType.assetsWithoutTag`）

### iOSのOn-Demand Resources仕様に関するメモ

#### AndroidのOn-Demand Resources Tagsの制限について

[ドキュメント](https://developer.apple.com/help/app-store-connect/reference/on-demand-resources-size-limits/)に記載があるようにiOS側にも制限があります。

- 縮小されたアセットパックのサイズ: 512 MB
- Initial installとprefetched tagsの合計サイズ: 4 GB
- アプリバンドルのサイズ: 2 GB

Android側の制限も把握して、どのようにアセットパックを分けるか考えてください。

基本的には、「iOSのアセットパックサイズ512MB以下」と、「Androidのアセットパック数100個以下」の制限を考慮して、アセットパックを分けていく形になると思われます。

将来的に制限に到達しそうであれば、「iOSのアセットパックを分割する」か、もしくは「Androidのアセットパックを合体させる」ことを行い、コード側でアセットパック名を呼び分けて制御する必要があります。

```.dart
OnlineAssets.instance.streamFile(
  assetName: Platform.isAndroid ? 'install_time_sample_pack' : 'install_time_sample_pack_1',
  relativePath: 'dog_image.png',
)
```

iOSでOn-Demand Resourcesを使用するために必要なものは以上で、残りは『Flutter関連実装』で後述します。

## Flutter関連実装

### 使用しているライブラリ

#### Pigeon

Flutterと各プラットフォーム間の連携は、[Pigeon](https://pub.dev/packages/pigeon)というライブラリを使用しています。

Pigeonライブラリ内の[Exampleアプリ](https://github.com/flutter/packages/tree/main/packages/pigeon/example/app)を参考に、実装を行っています。

Pigeonには、以下のような記載があります。

> ## Stability of generated code
> 
> Pigeon is intended to replace direct use of method channels in the internal implementation of plugins and applications. Because the expected use of Pigeon is as an internal implementation detail, its development strongly favors improvements to generated code over consistency with previous generated code, so breaking changes in generated code are common.
> 
> As a result, using Pigeon-generated code in public APIs is strongy discouraged, as doing so will likely create situations where you are unable to update to a new version of Pigeon without causing breaking changes for your clients.

これは、`@EventChannelApi()`や`@HostApi()`をつけてPigeonで生成したコード(`lib/on_demand_resources.g.dart`や`lib/play_asset_delivery.g.dart`)をライブラリ外で使用できるような形にしてはいけないという意味です。

そのため、ライブラリ化する際は、Pigeonから受け取った結果を処理したり、Pigeonを呼び出したりするクラス（OnlineAssetsクラスのようなもの）を作成してくださいということを意味しています。

もちろん、Pigeonを使わずにMethodChannelに書き換えても大丈夫です。

#### Freezed

Pigeonから受け取ったデータは、実装や加工がしやすいように[Freezed](https://pub.dev/packages/freezed)というライブラリを使用しました。

これは、Pigeonとやり取りするデータクラスを宣言するファイル（`pigeons/on_demand_resources.dart`や`pigeons/play_asset_delivery.dart`）ではPigeon以外のimportが使用できない制限があり、加工しやすいデータクラスとするためには別のファイル内で宣言する必要があるためです。

ですが、Freezedを使用した大きな理由はないため、Freezedを削除して`@immutable`のデータクラスとして実装しても問題ありません。

#### RxDart

Pigeonの`@EventChannelApi()`を使用して、プラットフォームからFlutterへパックの情報を送り続けます。

Flutter側では各パックの最新情報を保持し、Widgetなどで購読するタイミングでこれらの情報をStreamで取得できればいいなという思いがありました。

通常のStreamでは、購読した瞬間に最新情報を取得する仕組みはありません。

[RxDart](https://pub.dev/packages/rxdart)には、Streamを進化させたBehaviorSubjectというものがあり、これを使用するとStreamを購読したタイミングで最新値を取得できます。

その機能を目的としてRxDartを使用しているため、別ロジックで実装した場合はこのライブラリを削除することもできます。

#### Path

iOSのメソッドへ渡す値として、相対パスから拡張子を抜いたり、相対パスから拡張子のみを取り出すために使用しています。

簡単な処理のため、別ロジックで実装した場合はこのライブラリを削除することもできます。

#### Video Player

サンプルで大きいファイルサイズのアセットを扱うために採用しただけなので、もちろん削除できます。

## アセットファイルの受け渡し

プラットフォーム側のコードを見れば分かりますが、Androidのinstall-timeアセットとiOSの全アセットは、一時ファイルとしてコピーしてからそのパスを渡すという実装にしています。

これの理由としては、それらのファイル内容を取得することができても、それらのファイルパス自体を取得する方法が分かっていないためです。

そのため、ストレージを2倍圧迫してしまう問題が存在しています。

そして、読み込み速度を優先するため、既に保存されている一時ファイルがアセットと同じ内容かどうかについては、ファイルサイズのみで確認しています。
これにより、アプリのアップデートでアセットファイルが更新されても、ファイルサイズが全く同じであればコピーした一時ファイルを削除しないと過去のファイルを表示してしまう問題もあります。
（ただ、ファイルサイズが完全に一致するのに中身が異なることはあまり発生しないと思われます。）

これらのファイルパスを取得する方法を知っている方は、Issueやプルリクエストを送信してください。

データをbyteにして渡すことも検討しましたが、動画などのファイルサイズが膨大となった場合に、メモリを圧迫する可能性があり採用できませんでした。

プラットフォームとFlutter間で適切にデータの受け渡しを行って、Widgetで表示する方法を知っている方は、Issueやプルリクエストを送信してください。

## 実行スレッド

Androidでは、ファイル操作を行う箇所では`CoroutineScope(Dispatchers.IO)`を使用しています。

ただし、iOSではスレッドを意識した実装にできていません。（Todo）

もし、処理速度が気になる方や、スレッドや並列処理に知見がある方は、修正したプルリクエストを送信してください。

[DispatchQueue](https://developer.apple.com/documentation/dispatch/dispatchqueue)を使用せず、サンプルアプリをiOS 13.0+に変更して[Task](https://developer.apple.com/documentation/swift/task)を使用したプルリクエストでも構いません。

---

他の箇所に関しては、コードコメントを多めに追加したので、そちらを見て構造を把握してください！

もし、疑問点があればDiscussionsに書き込んでください。
