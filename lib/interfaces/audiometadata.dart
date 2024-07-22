import 'dart:typed_data';

class AudioMetaData {
  final String fileName;
  final Uint8List? albumCover;
  final int trackNumber;
  final String trackName;
  final String interpret;
  final String album;

  AudioMetaData({
    required this.fileName,
    this.albumCover,
    required this.trackNumber,
    required this.trackName,
    required this.interpret,
    required this.album,
  });
}
