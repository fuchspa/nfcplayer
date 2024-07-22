import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta_data_retriever/meta_data_retriever_platform_interface.dart';
import 'package:meta_data_retriever/model/metadata.dart';

/// An implementation of [MetaDataRetrieverPlatform] that uses method channels.
class MethodChannelMetaDataRetriever extends MetaDataRetrieverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('meta_data_retriever');

  @override
  Future<List<MetaData>> getMetaData(List<String> files) async {
    final rawMetaData = await methodChannel.invokeMethod(
      "getMetaData",
      {"files": files},
    );

    return rawMetaData
        .map<MetaData>((metaData) => MetaData.fromJson(metaData))
        .toList();
  }
}
