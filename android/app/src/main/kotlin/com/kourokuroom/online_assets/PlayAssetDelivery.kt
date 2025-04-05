package com.kourokuroom.online_assets

import AndroidAssetPackErrorCode
import AndroidAssetPackStatePigeon
import AndroidAssetPackStatesPigeon
import AndroidAssetPackStatus
import FlutterError
import PigeonEventSink
import PlayAssetDeliveryFlutterApi
import PlayAssetDeliveryHostApi
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
import io.flutter.embedding.engine.dart.DartExecutor
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import java.io.InputStream

// Pigeon Example
// https://github.com/flutter/packages/blob/pigeon-v25.1.0/packages/pigeon/example/app/android/app/src/main/kotlin/dev/flutter/pigeon_example_app/MainActivity.kt

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

class PlayAssetDeliveryApiImplementation : PlayAssetDeliveryHostApi {
    companion object {
        private const val TAG = "PlayAssetDeliveryApi"
    }

    private lateinit var assetPackManager: AssetPackManager
    private lateinit var assetManager: AssetManager
    private lateinit var cacheDir: File
    private lateinit var activityResultLauncher: ActivityResultLauncher<IntentSenderRequest>
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val ioScope = CoroutineScope(Dispatchers.IO)

    fun setup(
        flutterEngine: FlutterEngine,
        context: Context,
        mainActivity: MainActivity,
        pigeonFlutterApi: PigeonFlutterApi,
    ) {
        val methodInfo = "[setup(flutterEngine: $flutterEngine, context: $context)]"
        Log.d(TAG, "$methodInfo start")

        assetPackManager = AssetPackManagerFactory.getInstance(context)
        assetManager = context.assets
        cacheDir = File(context.cacheDir, "pad_cache")
        activityResultLauncher = mainActivity.registerForActivityResult(
            ActivityResultContracts.StartIntentSenderForResult()
        ) { result ->
            val callbackInfo = "[showConfirmationDialog callback(result: $result)]"
            Log.d(TAG, "$callbackInfo start")
            when (result.resultCode) {
                RESULT_OK -> {
                    pigeonFlutterApi.callbackConfirmationDialogResult(okArg = true, callback = {})
                    Log.d(TAG, "$callbackInfo Confirmation dialog has been accepted.")
                }

                RESULT_CANCELED -> {
                    pigeonFlutterApi.callbackConfirmationDialogResult(okArg = false, callback = {})
                    Log.d(TAG, "$callbackInfo Confirmation dialog has been denied by the user.")
                }

                else -> {
                    Log.d(
                        TAG,
                        "$callbackInfo Confirmation dialog unknown result code: ${result.resultCode}"
                    )
                }
            }
        }

        // Setup HostAPI
        PlayAssetDeliveryHostApi.setUp(
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
        relativeAssetPath: String,
        callback: (Result<String?>) -> Unit
    ) {
        ioScope.launch {
            try {
                val assetFileDescriptor = assetManager.openFd(relativeAssetPath)
                val copyFile = File(cacheDir, relativeAssetPath)

                val isExistCopyFile = copyFile.exists()

                if (!isExistCopyFile) {
                    // Failure to create a parent folder for the copy destination will result in failure when writing file.
                    val isNeedCreateParentFolder: Boolean
                    val parentCopyFile = copyFile.parentFile as File
                    if (parentCopyFile.exists()) {
                        if (parentCopyFile.isDirectory) {
                            isNeedCreateParentFolder = false
                        } else {
                            isNeedCreateParentFolder = true
                            Log.d(
                                TAG,
                                "$methodInfo Delete file with the same path as the target parent folder. $parentCopyFile"
                            )
                            parentCopyFile.delete()
                        }
                    } else {
                        isNeedCreateParentFolder = true
                    }

                    if (isNeedCreateParentFolder) {
                        Log.d(TAG, "$methodInfo Create parent folder. $parentCopyFile")
                        parentCopyFile.mkdirs()
                    }

                }

                if (isExistCopyFile) {
                    if (copyFile.length() == assetFileDescriptor.length) {
                        // Because of the time required, this function do not check file hash.
                        Log.d(TAG, "$methodInfo skip saving, same file size")
                        mainScope.launch {
                            callback(Result.success(copyFile.absolutePath))
                        }
                        return@launch
                    }
                }

                assetManager.open(relativeAssetPath).use { assetInputStream ->
                    copyFile.copyInputStreamToFile(assetInputStream)
                }
                mainScope.launch {
                    callback(Result.success(copyFile.absolutePath))
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

    override fun deleteCopiedAssetOnInstallTimeAsset(relativePath: String, callback: (Result<Boolean>) -> Unit) {
        val methodInfo =
            "[deleteCopiedAssetOnInstallTimeAsset(relativePath: $relativePath)]"
        Log.d(TAG, "$methodInfo start")

        ioScope.launch {
            try {
                val copyFile = File(cacheDir, relativePath)
                var result = true
                if (copyFile.exists()) {
                    result = copyFile.delete()
                }
                mainScope.launch {
                    callback(Result.success(result))
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

class PigeonFlutterApi(dartExecutor: DartExecutor) {
    private var flutterApi: PlayAssetDeliveryFlutterApi =
        PlayAssetDeliveryFlutterApi(dartExecutor.binaryMessenger)

    fun callbackConfirmationDialogResult(okArg: Boolean, callback: (Result<Unit>) -> Unit) {
        flutterApi.callbackConfirmationDialogResult(okArg) { echo -> callback(echo) }
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