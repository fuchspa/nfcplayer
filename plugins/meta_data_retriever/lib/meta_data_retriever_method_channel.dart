import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'meta_data_retriever_platform_interface.dart';

/// An implementation of [MetaDataRetrieverPlatform] that uses method channels.
class MethodChannelMetaDataRetriever extends MetaDataRetrieverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('meta_data_retriever');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
