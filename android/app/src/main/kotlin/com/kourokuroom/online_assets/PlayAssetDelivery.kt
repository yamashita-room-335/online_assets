package com.kourokuroom.online_assets

import AndroidAssetPackErrorCode
import AndroidAssetPackStatePigeon
import AndroidAssetPackStatesPigeon
import AndroidAssetPackStatus
import FlutterError
import PigeonEventSink
import PlayAssetDeliveryHostApiMethods
import StreamAssetPackStateStreamHandler
import android.content.Context
import com.google.android.play.core.assetpacks.AssetPackManager
import com.google.android.play.core.assetpacks.AssetPackManagerFactory
import com.google.android.play.core.assetpacks.AssetPackState
import com.google.android.play.core.assetpacks.AssetPackStateUpdateListener
import com.google.android.play.core.assetpacks.AssetPackStates
import com.google.android.play.core.assetpacks.model.AssetPackErrorCode
import com.google.android.play.core.assetpacks.model.AssetPackStatus
import com.google.android.play.core.ktx.requestFetch
import com.google.android.play.core.ktx.requestPackStates
import io.flutter.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File

class PlayAssetDeliveryPigeon(context: Context) : PlayAssetDeliveryHostApiMethods,
    StreamAssetPackStateStreamHandler() {
    private val tag = "AssetDelivery"
    private val assetPackManager: AssetPackManager = AssetPackManagerFactory.getInstance(context)
    private val scope = CoroutineScope(Dispatchers.Main)
    private var eventSink: PigeonEventSink<AndroidAssetPackStatePigeon>? = null
    private val assetPackStateUpdateListener = AssetPackStateUpdateListener { state ->
        eventSink?.success(state.convertPigeon())
    }

    companion object {
        fun register(flutterPluginBinding: io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding) {
            val plugin = PlayAssetDeliveryPigeon(flutterPluginBinding.applicationContext)

            // Register EventListener
            register(
                flutterPluginBinding.binaryMessenger,
                plugin
            )

            // Setup HostAPI
            PlayAssetDeliveryHostApiMethods.setUp(
                flutterPluginBinding.binaryMessenger,
                plugin
            )
        }
    }

    init {
        assetPackManager.registerListener(assetPackStateUpdateListener)
    }

    // EventChannel

    override fun onListen(p0: Any?, sink: PigeonEventSink<AndroidAssetPackStatePigeon>) {
        eventSink = sink
    }

    override fun onCancel(p0: Any?) {
        eventSink = null
    }

    // HostAPI

    override fun requestPackStates(
        packNames: List<String>,
        callback: (Result<AndroidAssetPackStatesPigeon>) -> Unit
    ) {
        scope.launch {
            try {
                val assetPackStates = assetPackManager.requestPackStates(packNames)
                Log.d(tag, "requestPackStates assetPackStates: $assetPackStates")
                callback(Result.success(assetPackStates.convertPigeon()))
            } catch (e: Exception) {
                callback(
                    Result.failure(
                        FlutterError(
                            code = tag,
                            message = e.message,
                            details = e.toString()
                        )
                    )
                )
            }
        }
    }

    override fun requestFetch(
        packNames: List<String>,
        callback: (Result<AndroidAssetPackStatesPigeon>) -> Unit
    ) {
        scope.launch {
            try {
                val assetPackStates = assetPackManager.requestFetch(packNames)
                Log.d(tag, "requestFetch assetPackStates: $assetPackStates")
                callback(Result.success(assetPackStates.convertPigeon()))
            } catch (e: Exception) {
                callback(
                    Result.failure(
                        FlutterError(
                            code = tag,
                            message = e.message,
                            details = e.toString()
                        )
                    )
                )
            }
        }
    }

    override fun getAbsoluteAssetPath(
        assetPackName: String,
        relativeAssetPath: String,
    ): String? {
        try {
            val assetPackLocation = assetPackManager.getPackLocation(assetPackName) ?: return null
            val assetsPath = assetPackLocation.assetsPath() ?: return null
            val file = File(assetsPath, relativeAssetPath)
            Log.d(tag, "file: $file")
            return file.absolutePath
        } catch (e: Exception) {
            throw FlutterError(
                code = tag,
                message = e.message,
                details = e.toString()
            )
        }
    }
}

fun AssetPackStates.convertPigeon(): AndroidAssetPackStatesPigeon {
    return AndroidAssetPackStatesPigeon(
        totalBytes = totalBytes(),
        packStates = packStates().mapValues { it.value.convertPigeon() }
    )
}

fun AssetPackState.convertPigeon(): AndroidAssetPackStatePigeon {
    return AndroidAssetPackStatePigeon(
        bytesDownloaded = bytesDownloaded(),
        errorCode = when (errorCode()) {
            AssetPackErrorCode.NO_ERROR -> AndroidAssetPackErrorCode.NO_ERROR
            AssetPackErrorCode.APP_UNAVAILABLE -> AndroidAssetPackErrorCode.APP_UNAVAILABLE
            AssetPackErrorCode.PACK_UNAVAILABLE -> AndroidAssetPackErrorCode.PACK_UNAVAILABLE
            AssetPackErrorCode.INVALID_REQUEST -> AndroidAssetPackErrorCode.INVALID_REQUEST
            AssetPackErrorCode.DOWNLOAD_NOT_FOUND -> AndroidAssetPackErrorCode.DOWNLOAD_NOT_FOUND
            AssetPackErrorCode.API_NOT_AVAILABLE -> AndroidAssetPackErrorCode.API_NOT_AVAILABLE
            AssetPackErrorCode.NETWORK_ERROR -> AndroidAssetPackErrorCode.NETWORK_ERROR
            AssetPackErrorCode.ACCESS_DENIED -> AndroidAssetPackErrorCode.ACCESS_DENIED
            AssetPackErrorCode.INSUFFICIENT_STORAGE -> AndroidAssetPackErrorCode.INSUFFICIENT_STORAGE
            AssetPackErrorCode.APP_NOT_OWNED -> AndroidAssetPackErrorCode.APP_NOT_OWNED
            AssetPackErrorCode.INTERNAL_ERROR -> AndroidAssetPackErrorCode.INTERNAL_ERROR
            AssetPackErrorCode.UNRECOGNIZED_INSTALLATION -> AndroidAssetPackErrorCode.UNRECOGNIZED_INSTALLATION
            else -> AndroidAssetPackErrorCode.UNKNOWN
        },
        name = name(),
        status = when (status()) {
            AssetPackStatus.UNKNOWN -> AndroidAssetPackStatus.UNKNOWN
            AssetPackStatus.PENDING -> AndroidAssetPackStatus.PENDING
            AssetPackStatus.DOWNLOADING -> AndroidAssetPackStatus.DOWNLOADING
            AssetPackStatus.TRANSFERRING -> AndroidAssetPackStatus.TRANSFERRING
            AssetPackStatus.COMPLETED -> AndroidAssetPackStatus.COMPLETED
            AssetPackStatus.FAILED -> AndroidAssetPackStatus.FAILED
            AssetPackStatus.CANCELED -> AndroidAssetPackStatus.CANCELED
            AssetPackStatus.WAITING_FOR_WIFI -> AndroidAssetPackStatus.WAITING_FOR_WIFI
            AssetPackStatus.NOT_INSTALLED -> AndroidAssetPackStatus.NOT_INSTALLED
            AssetPackStatus.REQUIRES_USER_CONFIRMATION -> AndroidAssetPackStatus.REQUIRES_USER_CONFIRMATION
            else -> AndroidAssetPackStatus.UNKNOWN
        },
        totalBytesToDownload = totalBytesToDownload(),
        transferProgressPercentage = transferProgressPercentage().toLong()
    )
}