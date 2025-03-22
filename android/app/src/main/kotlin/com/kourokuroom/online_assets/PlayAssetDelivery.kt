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
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
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
import io.flutter.embedding.android.FlutterFragmentActivity.RESULT_CANCELED
import io.flutter.embedding.android.FlutterFragmentActivity.RESULT_OK
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import java.io.InputStream

// Pigeon Example
// https://github.com/flutter/packages/blob/71a2e703a9de3afc450b4ffcf54064ba21cc0f4d/packages/pigeon/example/app/android/app/src/main/kotlin/dev/flutter/pigeon_example_app/MainActivity.kt

class PlayAssetDeliveryStreamHandler : StreamAssetPackStateStreamHandler() {
    private lateinit var assetPackManager: AssetPackManager
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private var eventSink: PigeonEventSink<AndroidAssetPackStatePigeon>? = null
    private val assetPackStateUpdateListener = AssetPackStateUpdateListener { state ->
        val methodInfo = "[assetPackStateUpdateListener(state: $state)]"
        Log.d(TAG, "$methodInfo call")

        mainScope.launch {
            eventSink?.success(state.convertPigeon())
        }
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

class PlayAssetDeliveryApiImplementation : PlayAssetDeliveryHostApiMethods {
    companion object {
        private const val TAG = "PlayAssetDeliveryApi"
    }

    private lateinit var assetPackManager: AssetPackManager
    private lateinit var assetManager: AssetManager
    private lateinit var cacheDir: File
    private lateinit var activityResultLauncher: ActivityResultLauncher<IntentSenderRequest>
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val ioScope = CoroutineScope(Dispatchers.IO)

    fun setup(flutterEngine: FlutterEngine, context: Context, mainActivity: MainActivity) {
        val methodInfo = "[setup(flutterEngine: $flutterEngine, context: $context)]"
        Log.d(TAG, "$methodInfo start")

        assetPackManager = AssetPackManagerFactory.getInstance(context)
        assetManager = context.assets
        ioScope.launch {
            cacheDir = File(context.cacheDir, "pad_cache").apply {
                if (!exists()) {
                    mkdirs()
                }
            }
        }
        activityResultLauncher = mainActivity.registerForActivityResult(
            ActivityResultContracts.StartIntentSenderForResult()
        ) { result ->
            val callbackInfo = "[showConfirmationDialog callback(result: $result)]"
            Log.d(TAG, "$callbackInfo start")
            if (result.resultCode == RESULT_OK) {
                Log.d(TAG, "$callbackInfo Confirmation dialog has been accepted.")
            } else if (result.resultCode == RESULT_CANCELED) {
                Log.d(TAG, "$callbackInfo Confirmation dialog has been denied by the user.")
            }
        }

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

        ioScope.launch {
            try {
                val assetPackStates = assetPackManager.requestPackStates(packNames)
                Log.d(
                    TAG,
                    "$methodInfo assetPackStates: $assetPackStates"
                )
                mainScope.launch {
                    callback(Result.success(assetPackStates.convertPigeon()))
                }
            } catch (e: Exception) {
                mainScope.launch {
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
    }

    override fun requestFetch(
        packNames: List<String>,
        callback: (Result<AndroidAssetPackStatesPigeon>) -> Unit
    ) {
        val methodInfo = "[requestFetch(packNames: $packNames)]"
        Log.d(TAG, "$methodInfo start")

        ioScope.launch {
            try {
                val assetPackStates = assetPackManager.requestFetch(packNames)
                Log.d(
                    TAG,
                    "$methodInfo assetPackStates: $assetPackStates"
                )
                mainScope.launch {
                    callback(Result.success(assetPackStates.convertPigeon()))
                }
            } catch (e: Exception) {
                mainScope.launch {
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
    }

    override fun showConfirmationDialog(): Boolean {
        return assetPackManager.showConfirmationDialog(activityResultLauncher)
    }

    override fun getCopiedAssetFilePathOnInstallTimeAsset(
        assetPackName: String,
        relativeAssetPath: String,
        callback: (Result<String?>) -> Unit
    ) {
        val methodInfo =
            "[getCopiedAssetFilePathOnInstallTimeAsset(assetPackName: $assetPackName, relativeAssetPath: $relativeAssetPath)]"
        Log.d(TAG, "$methodInfo start")

        ioScope.launch {
            try {
                val assetFileDescriptor = assetManager.openFd(relativeAssetPath)
                val targetFile =
                    File(cacheDir, (assetPackName + File.separator + relativeAssetPath))
                if (targetFile.exists()) {
                    if (targetFile.length() == assetFileDescriptor.length) {
                        // Because of the time required, this function do not check file hash.
                        Log.d(TAG, "$methodInfo skip saving, same file size")
                        mainScope.launch {
                            callback(Result.success(targetFile.absolutePath))
                        }
                        return@launch
                    }
                    Log.d(TAG, "$methodInfo Remove pre saved file")
                    targetFile.delete()
                } else if (targetFile.parentFile?.exists() == false) {
                    targetFile.parentFile?.mkdirs()
                }

                assetManager.open(relativeAssetPath).use { assetInputStream ->
                    targetFile.copyInputStreamToFile(assetInputStream)
                }
                mainScope.launch {
                    callback(Result.success(targetFile.absolutePath))
                }
            } catch (e: Exception) {
                mainScope.launch {
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
    }

    override fun deleteCopiedAssetFileOnInstallTimeAsset(
        assetPackName: String?,
        relativeAssetPath: String?,
        callback: (Result<Boolean>) -> Unit
    ) {
        val methodInfo =
            "[deleteCopiedAssetFileOnInstallTimeAsset(assetPackName: $assetPackName, relativeAssetPath: $relativeAssetPath)]"
        Log.d(TAG, "$methodInfo start")

        ioScope.launch {
            try {
                val targetFile = if (assetPackName == null) {
                    cacheDir
                } else if (relativeAssetPath == null) {
                    File(cacheDir, assetPackName)
                } else {
                    File(cacheDir, (assetPackName + File.separator + relativeAssetPath))
                }
                if (targetFile.exists()) {
                    mainScope.launch {
                        callback(Result.success(targetFile.delete()))
                    }
                }
                mainScope.launch {
                    callback(Result.success(true))
                }
            } catch (e: Exception) {
                mainScope.launch {
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
    }

    override fun getAssetFilePathOnDownloadAsset(
        assetPackName: String,
        relativeAssetPath: String,
        callback: (Result<String?>) -> Unit
    ) {
        val methodInfo =
            "[getAbsoluteAssetPath(assetPackName: $assetPackName, relativeAssetPath: $relativeAssetPath)]"
        Log.d(TAG, "$methodInfo start")

        ioScope.launch {
            try {
                val assetPackLocation = assetPackManager.getPackLocation(assetPackName)
                if (assetPackLocation == null) {
                    Log.d(TAG, "$methodInfo assetPackLocation is null")
                    mainScope.launch {
                        callback(Result.success(null))
                    }
                    return@launch
                }
                val assetsPath = assetPackLocation.assetsPath()
                if (assetsPath == null) {
                    Log.d(TAG, "$methodInfo assetsPath is null")
                    mainScope.launch {
                        callback(Result.success(null))
                    }
                    return@launch
                }
                val file = File(assetsPath, relativeAssetPath)
                Log.d(TAG, "$methodInfo file: $file")
                mainScope.launch {
                    callback(Result.success(file.absolutePath))
                }
            } catch (e: Exception) {
                mainScope.launch {
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
    }

    private fun File.copyInputStreamToFile(inputStream: InputStream) {
        this.outputStream().use { fileOut ->
            inputStream.copyTo(fileOut)
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