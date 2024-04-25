import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';

abstract class MetaDataFetcher {
  Future<Metadata> query(File audioFile);
}
