import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfcplayer/actualnfchandler.dart';
import 'package:nfcplayer/androidaudiofilepathprovider.dart';
import 'package:nfcplayer/androidpermissionprovider.dart';
import 'package:nfcplayer/filesystemmappingmanager.dart';
import 'package:nfcplayer/filesystemmappingstore.dart';
import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/depdencymanager.dart';
import 'package:nfcplayer/interfaces/ghettoblaster.dart';
import 'package:nfcplayer/interfaces/mappingmanager.dart';
import 'package:nfcplayer/interfaces/nfchandler.dart';
import 'package:nfcplayer/mp3ghettoblaster.dart';
import 'package:nfcplayer/mp3metadatafetcher.dart';
import 'package:nfcplayer/mp3metadataprovider.dart';
import 'package:path_provider/path_provider.dart';

class AndroidDepdencyManager extends DepdencyManager {
  late AudioFilePathProvider _audioFilePathProvider;
  late GhettoBlaster _ghettoBlaster;
  late MappingManager _mappingManager;
  late AudioMetaDataProvider _audioMetaDataProvider;
  late NfcHandler _nfcHandler;

  @override
  Future<DepdencyManager> allocateRessources() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    const localFileSystem = LocalFileSystem();
    final storageFile = File(
      "${documentDirectory.path}/mappings.json",
    );
    _nfcHandler = await ActualNfcHandler.allocateResource(
      NfcManager.instance,
    );
    _mappingManager = FilesystemMappingManager(
      store: FilesystemMappingStore(
        storageFile: storageFile,
      ),
    );
    final androidPermissionProvider = AndroidPermissionProvider();
    _audioFilePathProvider = AndroidAudioFilePathProvider(
      permissionProvider: androidPermissionProvider,
      fileSystem: localFileSystem,
      searchLocations: [localFileSystem.directory("/storage/emulated/0/Music")],
    );
    _ghettoBlaster = Mp3GhettoBlaster(
      audioPlayer: AudioPlayer(),
      permissionProvider: androidPermissionProvider,
    );
    _audioMetaDataProvider = Mp3MetaDataProvider(
      permissionProvider: androidPermissionProvider,
      metaDataFetcher: Mp3MetaDataFetcher(),
    );
    return this;
  }

  @override
  AudioFilePathProvider get audioFilePathProvider => _audioFilePathProvider;

  @override
  GhettoBlaster get ghettoBlaster => _ghettoBlaster;

  @override
  MappingManager get mappingManager => _mappingManager;

  @override
  AudioMetaDataProvider get audioMetaDataProvider => _audioMetaDataProvider;

  @override
  NfcHandler get nfcHandler => _nfcHandler;
}
