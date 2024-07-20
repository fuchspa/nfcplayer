
import 'meta_data_retriever_platform_interface.dart';

class MetaDataRetriever {
  Future<String?> getPlatformVersion() {
    return MetaDataRetrieverPlatform.instance.getPlatformVersion();
  }
}
