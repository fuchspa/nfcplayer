import 'package:nfcplayer/interfaces/mapping.dart';

abstract class MappingStore {
  Future<Mappings> load();
  Future<void> save(Mappings mappings);
}
