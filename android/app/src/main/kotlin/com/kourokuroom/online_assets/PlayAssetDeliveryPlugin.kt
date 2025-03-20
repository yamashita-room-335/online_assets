package com.kourokuroom.online_assets

import io.flutter.embedding.engine.plugins.FlutterPlugin

class PlayAssetDeliveryPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        PlayAssetDeliveryPigeon.onAttachedToEngine(binding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        PlayAssetDeliveryPigeon.onDetachedFromEngine(binding)
    }
}