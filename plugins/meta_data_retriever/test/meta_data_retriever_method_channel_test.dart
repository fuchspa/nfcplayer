import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta_data_retriever/meta_data_retriever_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMetaDataRetriever platform = MethodChannelMetaDataRetriever();
  const MethodChannel channel = MethodChannel('meta_data_retriever');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
