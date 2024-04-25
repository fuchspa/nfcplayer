import 'package:file/memory.dart';
import 'package:nfcplayer/filesystemmappingstore.dart';
import 'package:test/test.dart';

void main() {
  test("Mapping manager stores mappings", () async {
    final memoryFileSystem = MemoryFileSystem();
    final storageDirectory = memoryFileSystem.directory("Documents");
    final storageFile = storageDirectory.childFile("mappings.json");
    final mappingStore = FilesystemMappingStore(storageFile: storageFile);

    final mappings = {
      "abcdef0123456789": ["a.mp3", "b.mp3"],
      "fedcba9876543210": ["a.mp3", "c.mp3"],
    };
    await mappingStore.save(mappings);

    expect(await storageFile.exists(), isTrue);
    expect(
      await storageFile.readAsString(),
      "{\"abcdef0123456789\":[\"a.mp3\",\"b.mp3\"],\"fedcba9876543210\":[\"a.mp3\",\"c.mp3\"]}",
    );
  });

  test("Mapping manager reads mappings", () async {
    final memoryFileSystem = MemoryFileSystem();
    final storageDirectory = memoryFileSystem.directory("Documents");
    final storageFile = storageDirectory.childFile("mappings.json");
    await storageFile.create(recursive: true);
    await storageFile.writeAsString(
      "{\"abcdef0123456789\":[\"a.mp3\",\"b.mp3\"],\"fedcba9876543210\":[\"a.mp3\",\"c.mp3\"]}",
    );
    final mappingStore = FilesystemMappingStore(storageFile: storageFile);

    final mappings = await mappingStore.load();

    expect(
      mappings,
      {
        "abcdef0123456789": ["a.mp3", "b.mp3"],
        "fedcba9876543210": ["a.mp3", "c.mp3"],
      },
    );
  });
}
