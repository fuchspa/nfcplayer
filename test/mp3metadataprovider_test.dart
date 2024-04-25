import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_media_metadata/src/models/metadata.dart';
import 'package:nfcplayer/interfaces/metadatafetcher.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:nfcplayer/mp3metadataprovider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/test.dart';

class FakePermissionProvider extends PermissionProvider {
  int _requestCalls = 0;

  @override
  Future<void> request(List<Permission> permissions) async {
    _requestCalls += 1;
  }

  bool requestWasCalled() => _requestCalls > 0;
}

class FakeMetaDataFetcher extends MetaDataFetcher {
  final Metadata expectedMetadata;

  FakeMetaDataFetcher(this.expectedMetadata);

  @override
  Future<Metadata> query(File audioFile) async {
    return expectedMetadata;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test("Mp3 meta data provider provides results", () async {
    final fakePermissionProvider = FakePermissionProvider();
    final fakeMetaDataFetcher = FakeMetaDataFetcher(const Metadata());
    final metadataprovider = Mp3MetaDataProvider(
      permissionProvider: fakePermissionProvider,
      metaDataFetcher: fakeMetaDataFetcher,
    );

    final metaData = await metadataprovider.query(File("fakeaudio.mp3"));

    expect(metaData.album, "");
    expect(metaData.interpret, "");
    expect(metaData.trackNumber, 0);
  });
}
