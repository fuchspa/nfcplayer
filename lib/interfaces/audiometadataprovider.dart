import 'package:nfcplayer/interfaces/audiometadata.dart';

abstract class AudioMetaDataProvider {
  Future<AudioMetaData> query(String audioFile);
  Future<List<AudioMetaData>> queryList(List<String> audioFiles);
}
