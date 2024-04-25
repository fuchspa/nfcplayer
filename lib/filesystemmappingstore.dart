import 'dart:convert';
import 'dart:io';

import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/mappingstore.dart';

class FilesystemMappingStore extends MappingStore {
  final File storageFile;

  FilesystemMappingStore({
    required this.storageFile,
  });

  @override
  Future<void> save(Mappings mappings) async {
    if (!await storageFile.exists()) {
      await storageFile.create(recursive: true);
    }
    await storageFile.writeAsString(jsonEncode(mappings));
  }

  @override
  Future<Mappings> load() async {
    if (!await storageFile.exists()) {
      return {};
    }
    final content = await storageFile.readAsString();
    final mappings = jsonDecode(content) as Map;

    return mappings.map<String, List<String>>(
      (key, value) => MapEntry(
        key.toString(),
        _toStringList(value),
      ),
    );
  }

  List<String> _toStringList(value) {
    return (value as List).map((e) => e.toString()).toList();
  }
}
