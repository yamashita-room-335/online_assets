// Autogenerated from Pigeon (v25.3.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

private fun createConnectionError(channelName: String): FlutterError {
  return FlutterError("channel-error",  "Unable to establish connection on channel: '$channelName'.", "")}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()
private fun deepEqualsPlayAssetDelivery(a: Any?, b: Any?): Boolean {
  if (a is ByteArray && b is ByteArray) {
      return a.contentEquals(b)
  }
  if (a is IntArray && b is IntArray) {
      return a.contentEquals(b)
  }
  if (a is LongArray && b is LongArray) {
      return a.contentEquals(b)
  }
  if (a is DoubleArray && b is DoubleArray) {
      return a.contentEquals(b)
  }
  if (a is Array<*> && b is Array<*>) {
    return a.size == b.size &&
        a.indices.all{ deepEqualsPlayAssetDelivery(a[it], b[it]) }
  }
  if (a is List<*> && b is List<*>) {
    return a.size == b.size &&
        a.indices.all{ deepEqualsPlayAssetDelivery(a[it], b[it]) }
  }
  if (a is Map<*, *> && b is Map<*, *>) {
    return a.size == b.size && a.all {
        (b as Map<Any?, Any?>).containsKey(it.key) &&
        deepEqualsPlayAssetDelivery(it.value, b[it.key])
    }
  }
  return a == b
}
    

/** https://developer.android.com/reference/com/google/android/play/core/assetpacks/model/AssetPackErrorCode */
enum class AndroidAssetPackErrorCode(val raw: Int) {
  NO_ERROR(0),
  APP_UNAVAILABLE(1),
  PACK_UNAVAILABLE(2),
  INVALID_REQUEST(3),
  DOWNLOAD_NOT_FOUND(4),
  API_NOT_AVAILABLE(5),
  NETWORK_ERROR(6),
  ACCESS_DENIED(7),
  INSUFFICIENT_STORAGE(8),
  APP_NOT_OWNED(9),
  CONFIRMATION_NOT_REQUIRED(10),
  UNRECOGNIZED_INSTALLATION(11),
  INTERNAL_ERROR(12),
  UNKNOWN(13);

  companion object {
    fun ofRaw(raw: Int): AndroidAssetPackErrorCode? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** https://developer.android.com/reference/com/google/android/play/core/assetpacks/model/AssetPackStatus */
enum class AndroidAssetPackStatus(val raw: Int) {
  UNKNOWN(0),
  NOT_INSTALLED(1),
  PENDING(2),
  WAITING_FOR_WIFI(3),
  REQUIRES_USER_CONFIRMATION(4),
  DOWNLOADING(5),
  TRANSFERRING(6),
  COMPLETED(7),
  FAILED(8),
  CANCELED(9);

  companion object {
    fun ofRaw(raw: Int): AndroidAssetPackStatus? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/**
 * https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackStates
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class AndroidAssetPackStatesPigeon (
  /** Map from a pack's name to its state */
  val packStates: Map<String, AndroidAssetPackStatePigeon>,
  val totalBytes: Long
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): AndroidAssetPackStatesPigeon {
      val packStates = pigeonVar_list[0] as Map<String, AndroidAssetPackStatePigeon>
      val totalBytes = pigeonVar_list[1] as Long
      return AndroidAssetPackStatesPigeon(packStates, totalBytes)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      packStates,
      totalBytes,
    )
  }
  override fun equals(other: Any?): Boolean {
    if (other !is AndroidAssetPackStatesPigeon) {
      return false
    }
    if (this === other) {
      return true
    }
    return deepEqualsPlayAssetDelivery(toList(), other.toList())  }

  override fun hashCode(): Int = toList().hashCode()
}

/**
 * https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackState
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class AndroidAssetPackStatePigeon (
  val bytesDownloaded: Long,
  val errorCode: AndroidAssetPackErrorCode,
  val name: String,
  val status: AndroidAssetPackStatus,
  val totalBytesToDownload: Long,
  val transferProgressPercentage: Long
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): AndroidAssetPackStatePigeon {
      val bytesDownloaded = pigeonVar_list[0] as Long
      val errorCode = pigeonVar_list[1] as AndroidAssetPackErrorCode
      val name = pigeonVar_list[2] as String
      val status = pigeonVar_list[3] as AndroidAssetPackStatus
      val totalBytesToDownload = pigeonVar_list[4] as Long
      val transferProgressPercentage = pigeonVar_list[5] as Long
      return AndroidAssetPackStatePigeon(bytesDownloaded, errorCode, name, status, totalBytesToDownload, transferProgressPercentage)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      bytesDownloaded,
      errorCode,
      name,
      status,
      totalBytesToDownload,
      transferProgressPercentage,
    )
  }
  override fun equals(other: Any?): Boolean {
    if (other !is AndroidAssetPackStatePigeon) {
      return false
    }
    if (this === other) {
      return true
    }
    return deepEqualsPlayAssetDelivery(toList(), other.toList())  }

  override fun hashCode(): Int = toList().hashCode()
}
private open class PlayAssetDeliveryPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as Long?)?.let {
          AndroidAssetPackErrorCode.ofRaw(it.toInt())
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as Long?)?.let {
          AndroidAssetPackStatus.ofRaw(it.toInt())
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          AndroidAssetPackStatesPigeon.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          AndroidAssetPackStatePigeon.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is AndroidAssetPackErrorCode -> {
        stream.write(129)
        writeValue(stream, value.raw)
      }
      is AndroidAssetPackStatus -> {
        stream.write(130)
        writeValue(stream, value.raw)
      }
      is AndroidAssetPackStatesPigeon -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is AndroidAssetPackStatePigeon -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

val PlayAssetDeliveryPigeonMethodCodec = StandardMethodCodec(PlayAssetDeliveryPigeonCodec())



private class PlayAssetDeliveryPigeonStreamHandler<T>(
    val wrapper: PlayAssetDeliveryPigeonEventChannelWrapper<T>
) : EventChannel.StreamHandler {
  var pigeonSink: PigeonEventSink<T>? = null

  override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
    pigeonSink = PigeonEventSink<T>(sink)
    wrapper.onListen(p0, pigeonSink!!)
  }

  override fun onCancel(p0: Any?) {
    pigeonSink = null
    wrapper.onCancel(p0)
  }
}

interface PlayAssetDeliveryPigeonEventChannelWrapper<T> {
  open fun onListen(p0: Any?, sink: PigeonEventSink<T>) {}

  open fun onCancel(p0: Any?) {}
}

class PigeonEventSink<T>(private val sink: EventChannel.EventSink) {
  fun success(value: T) {
    sink.success(value)
  }

  fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
    sink.error(errorCode, errorMessage, errorDetails)
  }

  fun endOfStream() {
    sink.endOfStream()
  }
}
      
abstract class StreamAssetPackStateStreamHandler : PlayAssetDeliveryPigeonEventChannelWrapper<AndroidAssetPackStatePigeon> {
  companion object {
    fun register(messenger: BinaryMessenger, streamHandler: StreamAssetPackStateStreamHandler, instanceName: String = "") {
      var channelName: String = "dev.flutter.pigeon.online_assets.PlayAssetDeliveryEventChannelApi.streamAssetPackState"
      if (instanceName.isNotEmpty()) {
        channelName += ".$instanceName"
      }
      val internalStreamHandler = PlayAssetDeliveryPigeonStreamHandler<AndroidAssetPackStatePigeon>(streamHandler)
      EventChannel(messenger, channelName, PlayAssetDeliveryPigeonMethodCodec).setStreamHandler(internalStreamHandler)
    }
  }
}
      
/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface PlayAssetDeliveryHostApi {
  /** https://developer.android.com/reference/com/google/android/play/core/ktx/package-summary#requestpackstates */
  fun requestPackStates(packNames: List<String>, callback: (Result<AndroidAssetPackStatesPigeon>) -> Unit)
  /** https://developer.android.com/reference/com/google/android/play/core/ktx/package-summary#requestfetch */
  fun requestFetch(packNames: List<String>, callback: (Result<AndroidAssetPackStatesPigeon>) -> Unit)
  /** https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackManager#showCellularDataConfirmation(android.app.Activity) */
  fun showConfirmationDialog(): Boolean
  /**
   * Get the path to the copy of the Android install-time asset file.
   *
   * It is not possible to obtain the file path of the install-time asset file itself.
   * Therefore, the path of the file copied to temporary directory is obtained.
   *
   * If the file is still in the temporary folder when this function is called and the file size is the same as the asset, file is reused.
   * Therefore, if an asset is replaced by app update, etc., and the file size is exactly the same but the contents are different, there is a problem that the previous file will be used.
   * If you want to avoid this case, you call [deleteCopiedAssetFileOnInstallTimeAsset] function to delete cache on app update.
   * However, the possibility that the file contents are different and the file size is exactly the same is quite small, so you do not need to worry too much about it.
   *
   * Note that using this function uses twice as much device storage due to the assets of the system and the copied files.
   * The copied files will be deleted by system when storage space is running low due to temporary files, but will be copied again on use.
   */
  fun getCopiedAssetFilePathOnInstallTimeAsset(relativeAssetPath: String, callback: (Result<String?>) -> Unit)
  /**
   * Delete the copied asset file or directory.
   *
   * Returns true if the target file was successfully deleted.
   * Also returns true if the target file does not yet exist.
   *
   * If the file is still in the temporary folder when [getCopiedAssetFilePathOnInstallTimeAsset] function is called and the file size is the same as the asset, file is reused.
   * Therefore, if an asset is replaced by app update, and the file size is exactly the same but the contents are different, there is a problem that the previous file will be used.
   * If you want to avoid this case, you call delete function when your app update.
   * However, the possibility that the file contents are different and the file size is exactly the same is quite small, so you do not need to worry too much about it.
   */
  fun deleteCopiedAssetOnInstallTimeAsset(relativePath: String, callback: (Result<Boolean>) -> Unit)
  fun getAssetFilePathOnDownloadAsset(assetPackName: String, relativeAssetPath: String, callback: (Result<String?>) -> Unit)

  companion object {
    /** The codec used by PlayAssetDeliveryHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      PlayAssetDeliveryPigeonCodec()
    }
    /** Sets up an instance of `PlayAssetDeliveryHostApi` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: PlayAssetDeliveryHostApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.online_assets.PlayAssetDeliveryHostApi.requestPackStates$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val packNamesArg = args[0] as List<String>
            api.requestPackStates(packNamesArg) { result: Result<AndroidAssetPackStatesPigeon> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.online_assets.PlayAssetDeliveryHostApi.requestFetch$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val packNamesArg = args[0] as List<String>
            api.requestFetch(packNamesArg) { result: Result<AndroidAssetPackStatesPigeon> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.online_assets.PlayAssetDeliveryHostApi.showConfirmationDialog$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.showConfirmationDialog())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.online_assets.PlayAssetDeliveryHostApi.getCopiedAssetFilePathOnInstallTimeAsset$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val relativeAssetPathArg = args[0] as String
            api.getCopiedAssetFilePathOnInstallTimeAsset(relativeAssetPathArg) { result: Result<String?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.online_assets.PlayAssetDeliveryHostApi.deleteCopiedAssetOnInstallTimeAsset$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val relativePathArg = args[0] as String
            api.deleteCopiedAssetOnInstallTimeAsset(relativePathArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.online_assets.PlayAssetDeliveryHostApi.getAssetFilePathOnDownloadAsset$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val assetPackNameArg = args[0] as String
            val relativeAssetPathArg = args[1] as String
            api.getAssetFilePathOnDownloadAsset(assetPackNameArg, relativeAssetPathArg) { result: Result<String?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
class PlayAssetDeliveryFlutterApi(private val binaryMessenger: BinaryMessenger, private val messageChannelSuffix: String = "") {
  companion object {
    /** The codec used by PlayAssetDeliveryFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      PlayAssetDeliveryPigeonCodec()
    }
  }
  /** https://developer.android.com/reference/com/google/android/play/core/assetpacks/AssetPackManager#showCellularDataConfirmation(android.app.Activity) */
  fun callbackConfirmationDialogResult(okArg: Boolean, callback: (Result<Unit>) -> Unit)
{
    val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
    val channelName = "dev.flutter.pigeon.online_assets.PlayAssetDeliveryFlutterApi.callbackConfirmationDialogResult$separatedMessageChannelSuffix"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(okArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
}
