import 'package:nfcplayer/filesystemmappingmanager.dart';
import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/mappingstore.dart';
import 'package:test/test.dart';

class MockMappingStore implements MappingStore {
  int _saveCalls = 0;
  int _loadCalls = 0;
  Mappings? mappings;

  MockMappingStore({this.mappings});

  @override
  Future<void> save(Mappings mappings) async {
    _saveCalls += 1;
    this.mappings = mappings;
  }

  @override
  Future<Mappings> load() async {
    _loadCalls += 1;
    return mappings ?? {};
  }

  bool saveWasCalled() => _saveCalls > 0;
  bool loadWasCalled() => _loadCalls > 0;
}

void main() {
  test("Mapping manager accepts new mapping", () async {
    final mappingStore = MockMappingStore();
    final mappings = FilesystemMappingManager(store: mappingStore);

    const NfcKey key = "abcdef09";
    final Playlist playlist = ["01.mp3", "02.mp3"];

    await mappings.add(key, playlist);

    expect(mappingStore.saveWasCalled(), isTrue);
    expect(await mappings.query(key), playlist);
  });

  test("Mapping manager overwrites existing mapping", () async {
    final mappingStore = MockMappingStore();
    final mappings = FilesystemMappingManager(store: mappingStore);

    const NfcKey key = "abcdef09";
    final Playlist playlist1 = ["01.mp3", "02.mp3"];
    final Playlist playlist2 = ["02.mp3", "03.mp3"];

    await mappings.add(key, playlist1);
    await mappings.add(key, playlist2);

    expect(mappingStore.saveWasCalled(), isTrue);
    expect(await mappings.query(key), playlist2);
  });

  test("Mapping manager deletes on empty playlist", () async {
    final mappingStore = MockMappingStore();
    final mappings = FilesystemMappingManager(store: mappingStore);

    const NfcKey key = "abcdef09";
    final Playlist playlist1 = ["01.mp3", "02.mp3"];
    final Playlist playlist2 = [];

    await mappings.add(key, playlist1);
    await mappings.add(key, playlist2);

    expect(mappingStore.saveWasCalled(), isTrue);
    expect(await mappings.query(key), playlist2);
    expect(mappingStore.mappings, {});
  });
}
