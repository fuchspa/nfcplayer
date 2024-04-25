import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:nfcplayer/interfaces/metadatafetcher.dart';

class Mp3MetaDataFetcher extends MetaDataFetcher {
  @override
  Future<Metadata> query(File audioFile) {
    return MetadataRetriever.fromFile(audioFile);
  }
}
