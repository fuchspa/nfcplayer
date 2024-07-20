import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'meta_data_retriever_method_channel.dart';

abstract class MetaDataRetrieverPlatform extends PlatformInterface {
  /// Constructs a MetaDataRetrieverPlatform.
  MetaDataRetrieverPlatform() : super(token: _token);

  static final Object _token = Object();

  static MetaDataRetrieverPlatform _instance = MethodChannelMetaDataRetriever();

  /// The default instance of [MetaDataRetrieverPlatform] to use.
  ///
  /// Defaults to [MethodChannelMetaDataRetriever].
  static MetaDataRetrieverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MetaDataRetrieverPlatform] when
  /// they register themselves.
  static set instance(MetaDataRetrieverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
