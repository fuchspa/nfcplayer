import 'package:meta_data_retriever/meta_data_retriever.dart';
import 'package:nfcplayer/interfaces/audiometadata.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:permission_handler/permission_handler.dart';

class Mp3MetaDataProvider implements AudioMetaDataProvider {
  final PermissionProvider permissionProvider;
  final MetaDataRetriever metaDataRetriever = MetaDataRetriever();

  Mp3MetaDataProvider({
    required this.permissionProvider,
  });

  @override
  Future<AudioMetaData> query(String audioFile) async {
    final metaData = await queryList([audioFile]);
    return metaData[0];
  }

  @override
  Future<List<AudioMetaData>> queryList(List<String> audioFiles) async {
    List<Permission> permissions = [
      Permission.storage,
      Permission.audio,
    ];
    await permissionProvider.request(permissions);

    final metadata = await metaDataRetriever.getMetaData(audioFiles);

    return metadata
        .map<AudioMetaData>(
          (m) => AudioMetaData(
            trackNumber: m.trackNumber,
            trackName: m.title,
            interpret: m.artist,
            album: m.album,
          ),
        )
        .toList();
  }
}
