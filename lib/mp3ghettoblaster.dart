import 'package:audioplayers/audioplayers.dart';
import 'package:nfcplayer/interfaces/ghettoblaster.dart';
import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:permission_handler/permission_handler.dart';

class Mp3GhettoBlaster extends GhettoBlaster {
  final List<Future<void> Function(String)> _onNextTrackListeners = [];

  final PermissionProvider permissionProvider;
  final AudioPlayer audioPlayer;

  Playlist playlist = [];
  int currentTrack = 0;
  bool paused = true;

  Mp3GhettoBlaster({
    required this.audioPlayer,
    required this.permissionProvider,
  }) {
    audioPlayer.onPlayerComplete.listen(
      (event) async {
        next();
      },
    );
  }

  @override
  Future<void> resume() async {
    if (playlist.isEmpty) {
      return;
    }

    paused = false;
    await audioPlayer.resume();
  }

  @override
  bool hasNext() {
    return currentTrack + 1 < playlist.length;
  }

  @override
  bool hasPrevious() {
    return currentTrack - 1 >= 0;
  }

  @override
  bool isPaused() {
    return paused;
  }

  @override
  Future<void> next() async {
    if (!hasNext()) {
      return;
    }

    currentTrack += 1;
    _play();
  }

  @override
  Future<void> pause() async {
    paused = true;
    await audioPlayer.pause();
  }

  @override
  Future<void> playAll(Playlist playlist) async {
    this.playlist = playlist;
    currentTrack = 0;

    if (this.playlist.isEmpty) {
      return;
    }

    await _play();
  }

  @override
  Future<void> previous() async {
    if (!hasPrevious()) {
      return;
    }

    currentTrack -= 1;
    await _play();
  }

  Future<void> _play() async {
    List<Permission> permissions = [
      Permission.storage,
      Permission.audio,
    ];
    await permissionProvider.request(permissions);

    paused = false;
    final audioFile = playlist[currentTrack];
    for (final onNextTrack in _onNextTrackListeners) {
      onNextTrack(audioFile);
    }
    await audioPlayer.play(DeviceFileSource(audioFile));
  }

  @override
  void register(Future<void> Function(String) onNextTrack) {
    if (!_onNextTrackListeners.contains(onNextTrack)) {
      _onNextTrackListeners.add(onNextTrack);
    }
  }

  @override
  void unregister(Future<void> Function(String) onNextTrack) {
    _onNextTrackListeners.remove(onNextTrack);
  }
}
