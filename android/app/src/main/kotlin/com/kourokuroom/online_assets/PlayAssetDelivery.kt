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
import android.content.res.AssetManager
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
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File

class PlayAssetDeliveryApiImplementation : PlayAssetDeliveryHostApiMethods {
    companion object {
        private const val TAG = "PlayAssetDeliveryApi"
    }

    private lateinit var assetPackManager: AssetPackManager
    private lateinit var assetManager: AssetManager
    private val scope = CoroutineScope(Dispatchers.Main)

    fun setup(flutterEngine: FlutterEngine, context: Context) {
        val methodInfo = "[setup(flutterEngine: $flutterEngine, context: $context)]"
        Log.d(TAG, "$methodInfo start")

        assetPackManager = AssetPackManagerFactory.getInstance(context)
        assetManager = context.assets

        // Setup HostAPI
        PlayAssetDeliveryHostApiMethods.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            this
        )
    }

    override fun requestPackStates(
        packNames: List<String>,
        callback: (Result<AndroidAssetPackStatesPigeon>) -> Unit
    ) {
        val methodInfo = "[requestPackStates(packNames: $packNames)]"
        Log.d(TAG, "$methodInfo start")

        scope.launch {
            try {
                val assetPackStates = assetPackManager.requestPackStates(packNames)
                Log.d(
                    TAG,
                    "$methodInfo assetPackStates: $assetPackStates"
                )
                callback(Result.success(assetPackStates.convertPigeon()))
            } catch (e: Exception) {
                callback(
                    Result.failure(
                        FlutterError(
                            code = TAG,
                            message = methodInfo + e.message,
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
        val methodInfo = "[requestFetch(packNames: $packNames)]"
        Log.d(TAG, "$methodInfo start")

        scope.launch {
            try {
                val assetPackStates = assetPackManager.requestFetch(packNames)
                Log.d(
                    TAG,
                    "$methodInfo assetPackStates: $assetPackStates"
                )
                callback(Result.success(assetPackStates.convertPigeon()))
            } catch (e: Exception) {
                callback(
                    Result.failure(
                        FlutterError(
                            code = TAG,
                            message = methodInfo + e.message,
                            details = e.toString()
                        )
                    )
                )
            }
        }
    }

    override fun getCopiedAssetFilePathOnInstallTimeAsset(
        assetPackName: String,
        relativeAssetPath: String
    ): String {
        val methodInfo =
            "[getCopiedAssetFilePathOnInstallTimeAsset(assetPackName: $assetPackName, relativeAssetPath: $relativeAssetPath)]"
        Log.d(TAG, "$methodInfo start")

        try {
            val file = createTempFile()
            file.writeBytes(assetManager.open(relativeAssetPath).readBytes())
            return file.absolutePath
        } catch (e: Exception) {
            throw FlutterError(
                code = TAG,
                message = methodInfo + e.message,
                details = e.toString()
            )
        }
    }

    override fun getAssetFilePathOnDownloadAsset(
        assetPackName: String,
        relativeAssetPath: String
    ): String? {
        val methodInfo =
            "[getAbsoluteAssetPath(assetPackName: $assetPackName, relativeAssetPath: $relativeAssetPath)]"
        Log.d(TAG, "$methodInfo start")

        try {
            val assetPackLocation = assetPackManager.getPackLocation(assetPackName) ?: return null
            val assetsPath = assetPackLocation.assetsPath() ?: return null
            val file = File(assetsPath, relativeAssetPath)
            Log.d(TAG, "$methodInfo file: $file")
            return file.absolutePath
        } catch (e: Exception) {
            throw FlutterError(
                code = TAG,
                message = methodInfo + e.message,
                details = e.toString()
            )
        }
    }
}

class PlayAssetDeliveryStreamHandler : StreamAssetPackStateStreamHandler() {
    private lateinit var assetPackManager: AssetPackManager
    private var eventSink: PigeonEventSink<AndroidAssetPackStatePigeon>? = null
    private val assetPackStateUpdateListener = AssetPackStateUpdateListener { state ->
        val methodInfo = "[assetPackStateUpdateListener(state: $state)]"
        Log.d(TAG, "$methodInfo call")

        eventSink?.success(state.convertPigeon())
    }

    companion object {
        private const val TAG = "PlayAssetDeliveryStreamHandler"
    }

    fun register(flutterEngine: FlutterEngine, context: Context) {
        val methodInfo = "[register(flutterEngine: $flutterEngine, context: $context)]"
        Log.d(TAG, "$methodInfo start")

        assetPackManager = AssetPackManagerFactory.getInstance(context)

        // Register EventListener
        register(
            flutterEngine.dartExecutor.binaryMessenger,
            this
        )

        assetPackManager.registerListener(assetPackStateUpdateListener)
    }

    override fun onListen(p0: Any?, sink: PigeonEventSink<AndroidAssetPackStatePigeon>) {
        val methodInfo = "[onListen(p0: $p0, sink: $sink)]"
        Log.d(TAG, "$methodInfo start")

        eventSink = sink
    }

    override fun onCancel(p0: Any?) {
        val methodInfo = "[onCancel(p0: $p0)]"
        Log.d(TAG, "$methodInfo start")

        eventSink = null
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