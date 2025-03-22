package com.kourokuroom.online_assets

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val playAssetDeliveryStreamHandler = PlayAssetDeliveryStreamHandler()
        playAssetDeliveryStreamHandler.register(flutterEngine, applicationContext)

        val playAssetDeliveryApi = PlayAssetDeliveryApiImplementation()
        playAssetDeliveryApi.setup(flutterEngine, applicationContext, this)
    }
}
