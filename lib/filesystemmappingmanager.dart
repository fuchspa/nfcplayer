import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/mappingmanager.dart';
import 'package:nfcplayer/interfaces/mappingstore.dart';

class FilesystemMappingManager extends MappingManager {
  final MappingStore store;
  Mappings mappings = {};

  FilesystemMappingManager({required this.store});

  @override
  Future<void> add(NfcKey key, Playlist playlist) async {
    if (playlist.isEmpty) {
      mappings.remove(key);
    } else {
      mappings[key] = playlist;
    }
    await store.save(mappings);
  }

  @override
  Future<Playlist> query(NfcKey key) async {
    mappings = await store.load();
    if (mappings.containsKey(key)) {
      return mappings[key]!;
    } else {
      return [];
    }
  }
}
