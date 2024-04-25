import 'package:file/memory.dart';
import 'package:nfcplayer/androidaudiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/test.dart';

class FakePermissionProvider implements PermissionProvider {
  int _requestCalls = 0;

  @override
  Future<void> request(List<Permission> permissions) async {
    _requestCalls += 1;
  }

  bool requestWasCalled() => _requestCalls > 0;
}

void main() {
  test("Audio file path provider checks for permissions", () async {
    final fakePermissionProvider = FakePermissionProvider();
    final memoryFileSystem = MemoryFileSystem();
    final audioProvider = AndroidAudioFilePathProvider(
      permissionProvider: fakePermissionProvider,
      fileSystem: memoryFileSystem,
      searchLocations: [],
    );

    final audioFiles = await audioProvider.listAllAudioFilePaths();

    expect(fakePermissionProvider.requestWasCalled(), isTrue);
    expect(audioFiles, equals([]));
  });

  test("Audio file path provider lists all available audio files", () async {
    final fakePermissionProvider = FakePermissionProvider();
    final memoryFileSystem = MemoryFileSystem();
    final testDirectory = memoryFileSystem.directory("testDir");
    testDirectory.createSync(recursive: true);
    final mp3File = testDirectory.childFile("a.mp3");
    mp3File.createSync();
    final jpgFile = testDirectory.childFile("b.jpg");
    jpgFile.createSync();
    final audioProvider = AndroidAudioFilePathProvider(
      permissionProvider: fakePermissionProvider,
      fileSystem: memoryFileSystem,
      searchLocations: [testDirectory],
    );

    final audioFiles = await audioProvider.listAllAudioFilePaths();

    expect(fakePermissionProvider.requestWasCalled(), isTrue);
    expect(audioFiles, equals([mp3File.absolute.path]));
  });
}
