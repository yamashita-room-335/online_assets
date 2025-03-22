package com.kourokuroom.online_assets

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val playAssetDeliveryStreamHandler = PlayAssetDeliveryStreamHandler()
        playAssetDeliveryStreamHandler.register(flutterEngine, context)

        val playAssetDeliveryApi = PlayAssetDeliveryApiImplementation()
        playAssetDeliveryApi.setup(flutterEngine, context)
    }
}
