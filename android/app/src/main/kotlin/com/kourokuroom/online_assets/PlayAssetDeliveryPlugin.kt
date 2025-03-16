package com.kourokuroom.online_assets

import io.flutter.embedding.engine.plugins.FlutterPlugin

class PlayAssetDeliveryPlugin : FlutterPlugin {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        PlayAssetDeliveryPigeon.register(flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // If resources need to be released, do so here
    }
}