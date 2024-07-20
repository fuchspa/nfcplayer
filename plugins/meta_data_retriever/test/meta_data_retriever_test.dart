import 'package:flutter_test/flutter_test.dart';
import 'package:meta_data_retriever/meta_data_retriever.dart';
import 'package:meta_data_retriever/meta_data_retriever_platform_interface.dart';
import 'package:meta_data_retriever/meta_data_retriever_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMetaDataRetrieverPlatform
    with MockPlatformInterfaceMixin
    implements MetaDataRetrieverPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MetaDataRetrieverPlatform initialPlatform = MetaDataRetrieverPlatform.instance;

  test('$MethodChannelMetaDataRetriever is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMetaDataRetriever>());
  });

  test('getPlatformVersion', () async {
    MetaDataRetriever metaDataRetrieverPlugin = MetaDataRetriever();
    MockMetaDataRetrieverPlatform fakePlatform = MockMetaDataRetrieverPlatform();
    MetaDataRetrieverPlatform.instance = fakePlatform;

    expect(await metaDataRetrieverPlugin.getPlatformVersion(), '42');
  });
}
