import 'package:nfcplayer/interfaces/mapping.dart';

abstract class MappingManager {
  Future<void> add(NfcKey key, Playlist playlist);
  Future<Playlist> query(NfcKey key);
}
