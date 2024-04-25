import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/ghettoblaster.dart';
import 'package:nfcplayer/interfaces/mappingmanager.dart';
import 'package:nfcplayer/interfaces/nfchandler.dart';

abstract class DepdencyManager {
  Future<DepdencyManager> allocateRessources();

  AudioFilePathProvider get audioFilePathProvider;
  MappingManager get mappingManager;
  NfcHandler get nfcHandler;
  GhettoBlaster get ghettoBlaster;
  AudioMetaDataProvider get audioMetaDataProvider;
}
