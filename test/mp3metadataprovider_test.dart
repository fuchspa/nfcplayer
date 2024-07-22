import 'package:flutter/widgets.dart' hide MetaData;
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test("Mp3 meta data provider provides results", () async {
    final fakePermissionProvider = FakePermissionProvider();
    final metadataprovider = Mp3MetaDataProvider(
      permissionProvider: fakePermissionProvider,
    );

    final metaData = await metadataprovider.query("fakeaudio.mp3");

    expect(metaData.album, "");
    expect(metaData.interpret, "");
    expect(metaData.trackNumber, 0);
  });
}
