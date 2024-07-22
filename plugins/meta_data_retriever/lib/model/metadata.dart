import 'dart:typed_data';

class MetaData {
  final String fileName;
  final int trackNumber;
  final String title;
  final String album;
  final String artist;
  final Uint8List cover;

  const MetaData(this.fileName, this.trackNumber, this.title, this.album,
      this.artist, this.cover);

  factory MetaData.fromJson(dynamic map) => MetaData(
        map["fileName"].toString(),
        int.parse(map["trackNumber"].toString()),
        map["title"].toString(),
        map["album"].toString(),
        map["artist"].toString(),
        map["cover"] as Uint8List,
      );
}
