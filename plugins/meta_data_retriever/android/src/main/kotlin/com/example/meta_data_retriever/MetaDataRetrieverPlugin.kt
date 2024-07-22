package com.example.meta_data_retriever

import androidx.annotation.NonNull
import android.media.MediaMetadataRetriever;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MetaDataRetrieverPlugin */
class MetaDataRetrieverPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "meta_data_retriever")
    channel.setMethodCallHandler(this)
  }

  private fun getMetaDataFor(file: String, retriever: MediaMetadataRetriever): Map<String, Object> {
    retriever.setDataSource(file)

    var trackNumber = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CD_TRACK_NUMBER)
    if (trackNumber!!.contains("/")) {
      trackNumber = trackNumber!!.split("/")[0]
    }

    var cover = retriever.getEmbeddedPicture();
    if (cover == null) {
      cover = byteArrayOf()
    }

    val metadata = mapOf<String, Object>(
      "fileName" to file as Object,
      "trackNumber" to trackNumber as Object,
      "title" to retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE) as Object,
      "artist" to retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST) as Object,
      "album" to retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM) as Object,
      "cover" to cover as Object,
    )
    return metadata
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getMetaData") {
      val retriever = MediaMetadataRetriever()
      val files = call.argument<List<String>>("files")
      val metadatas = files?.map({f: String -> getMetaDataFor(f, retriever)})
      result.success(metadatas)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
