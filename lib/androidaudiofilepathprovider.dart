import 'package:file/file.dart';
import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidAudioFilePathProvider extends AudioFilePathProvider {
  final PermissionProvider permissionProvider;
  final FileSystem fileSystem;
  final List<Directory> searchLocations;

  // Directory dir = Directory("/storage/emulated/0/Music");
  AndroidAudioFilePathProvider({
    required this.permissionProvider,
    required this.fileSystem,
    required this.searchLocations,
  });

  @override
  Future<List<String>> listAllAudioFilePaths() async {
    List<Permission> permissions = [
      Permission.storage,
      Permission.audio,
    ];
    await permissionProvider.request(permissions);

    List<String> songs = [];
    for (final searchLocation in searchLocations) {
      final allFiles = await searchLocation
          .list(recursive: true, followLinks: false)
          .where((x) => fileSystem.isFileSync(x.path) && x.path.endsWith("mp3"))
          .map((x) => x.absolute.path)
          .toList();
      songs.addAll(allFiles);
    }

    return songs;
  }
}
