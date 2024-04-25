import 'dart:io';

import 'package:nfcplayer/interfaces/audiometadata.dart';

abstract class AudioMetaDataProvider {
  Future<AudioMetaData> query(File audioFile);
}
