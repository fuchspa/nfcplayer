import 'package:nfcplayer/interfaces/mapping.dart';

abstract class GhettoBlaster {
  Future<void> playAll(Playlist playlist);

  Future<void> pause();
  Future<void> resume();
  bool isPaused();

  Future<void> next();
  bool hasNext();
  Future<void> previous();
  bool hasPrevious();

  void register(Future<void> Function(String) onNextTrack);
  void unregister(Future<void> Function(String) onNextTrack);
}
