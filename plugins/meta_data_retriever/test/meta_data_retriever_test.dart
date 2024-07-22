import 'package:flutter_test/flutter_test.dart';
import 'package:meta_data_retriever/meta_data_retriever.dart';
import 'package:meta_data_retriever/meta_data_retriever_platform_interface.dart';
import 'package:meta_data_retriever/meta_data_retriever_method_channel.dart';
import 'package:meta_data_retriever/model/metadata.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMetaDataRetrieverPlatform
    with MockPlatformInterfaceMixin
    implements MetaDataRetrieverPlatform {
  @override
  Future<List<MetaData>> getMetaData(List<String> files) => Future.value([]);
}

void main() {
  final MetaDataRetrieverPlatform initialPlatform =
      MetaDataRetrieverPlatform.instance;

  test('$MethodChannelMetaDataRetriever is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMetaDataRetriever>());
  });

  test('getPlatformVersion', () async {
    MetaDataRetriever metaDataRetrieverPlugin = MetaDataRetriever();
    MockMetaDataRetrieverPlatform fakePlatform =
        MockMetaDataRetrieverPlatform();
    MetaDataRetrieverPlatform.instance = fakePlatform;

    expect(await metaDataRetrieverPlugin.getMetaData([]), []);
  });
}
