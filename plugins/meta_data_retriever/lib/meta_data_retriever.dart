import 'package:meta_data_retriever/meta_data_retriever_platform_interface.dart';
import 'package:meta_data_retriever/model/metadata.dart';

class MetaDataRetriever {
  Future<List<MetaData>> getMetaData(List<String> files) {
    return MetaDataRetrieverPlatform.instance.getMetaData(files);
  }
}
