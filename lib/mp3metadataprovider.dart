import 'dart:io';

import 'package:nfcplayer/interfaces/audiometadata.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/metadatafetcher.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:permission_handler/permission_handler.dart';

class Mp3MetaDataProvider implements AudioMetaDataProvider {
  final PermissionProvider permissionProvider;
  final MetaDataFetcher metaDataFetcher;

  Mp3MetaDataProvider({
    required this.permissionProvider,
    required this.metaDataFetcher,
  });

  @override
  Future<AudioMetaData> query(File audioFile) async {
    List<Permission> permissions = [
      Permission.storage,
      Permission.audio,
    ];
    await permissionProvider.request(permissions);

    final metadata = await metaDataFetcher.query(audioFile);

    return AudioMetaData(
      trackNumber: metadata.trackNumber ?? 0,
      trackName: metadata.trackName ?? "",
      interpret: metadata.albumArtistName ?? "",
      album: metadata.albumName ?? "",
      albumCover: metadata.albumArt,
    );
  }
}
