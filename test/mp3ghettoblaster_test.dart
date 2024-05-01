import 'dart:async';

import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:nfcplayer/mp3ghettoblaster.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/test.dart';

class FakeAudioPlayer implements AudioPlayer {
  @override
  AudioCache get audioCache => throw UnimplementedError();

  @override
  PlayerState get desiredState => throw UnimplementedError();

  @override
  String get playerId => throw UnimplementedError();

  @override
  PlayerState get state => throw UnimplementedError();

  @override
  double get balance => throw UnimplementedError();

  @override
  Completer<void> get creatingCompleter => throw UnimplementedError();

  @override
  Future<void> dispose() {
    throw UnimplementedError();
  }

  @override
  Stream<AudioEvent> get eventStream => throw UnimplementedError();

  @override
  Future<Duration?> getCurrentPosition() {
    throw UnimplementedError();
  }

  @override
  Future<Duration?> getDuration() {
    throw UnimplementedError();
  }

  @override
  PlayerMode get mode => throw UnimplementedError();

  @override
  Stream<Duration> get onDurationChanged => throw UnimplementedError();

  @override
  Stream<String> get onLog => throw UnimplementedError();

  @override
  Stream<void> get onPlayerComplete async* {}

  @override
  Stream<PlayerState> get onPlayerStateChanged => throw UnimplementedError();

  @override
  Stream<Duration> get onPositionChanged => throw UnimplementedError();

  @override
  Stream<void> get onSeekComplete => throw UnimplementedError();

  @override
  Future<void> pause() {
    throw UnimplementedError();
  }

  @override
  Future<void> play(Source source,
      {double? volume,
      double? balance,
      AudioContext? ctx,
      Duration? position,
      PlayerMode? mode}) async {}

  @override
  double get playbackRate => throw UnimplementedError();

  @override
  Future<void> release() {
    throw UnimplementedError();
  }

  @override
  ReleaseMode get releaseMode => throw UnimplementedError();

  @override
  Future<void> resume() {
    throw UnimplementedError();
  }

  @override
  Future<void> seek(Duration position) {
    throw UnimplementedError();
  }

  @override
  Future<void> setAudioContext(AudioContext ctx) {
    throw UnimplementedError();
  }

  @override
  Future<void> setBalance(double balance) {
    throw UnimplementedError();
  }

  @override
  Future<void> setPlaybackRate(double playbackRate) {
    throw UnimplementedError();
  }

  @override
  Future<void> setPlayerMode(PlayerMode mode) {
    throw UnimplementedError();
  }

  @override
  Future<void> setReleaseMode(ReleaseMode releaseMode) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSource(Source source) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSourceAsset(String path, {String? mimeType}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSourceBytes(Uint8List bytes, {String? mimeType}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSourceDeviceFile(String path, {String? mimeType}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSourceUrl(String url, {String? mimeType}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setVolume(double volume) {
    throw UnimplementedError();
  }

  @override
  Source? get source => throw UnimplementedError();

  @override
  Future<void> stop() {
    throw UnimplementedError();
  }

  @override
  double get volume => throw UnimplementedError();

  @override
  set audioCache(AudioCache audioCache) {
    throw UnimplementedError();
  }

  @override
  set positionUpdater(PositionUpdater? positionUpdater) {
    throw UnimplementedError();
  }

  @override
  set desiredState(PlayerState desiredState) {
    throw UnimplementedError();
  }

  @override
  set state(PlayerState state) {
    throw UnimplementedError();
  }
}

class FakePermissionProvider extends PermissionProvider {
  int _requestCalls = 0;

  @override
  Future<void> request(List<Permission> permissions) async {
    _requestCalls += 1;
  }

  bool requestWasCalled() => _requestCalls > 0;
}

void main() {
  test("Fresh ghetto blaster is paused", () {
    final fakeAudioPlayer = FakeAudioPlayer();
    final fakePermissionProvider = FakePermissionProvider();
    final ghettoBlaster = Mp3GhettoBlaster(
      audioPlayer: fakeAudioPlayer,
      permissionProvider: fakePermissionProvider,
    );

    expect(ghettoBlaster.isPaused(), isTrue);
    expect(ghettoBlaster.hasNext(), isFalse);
    expect(ghettoBlaster.hasPrevious(), isFalse);
  });

  test("Mp3GhettoBlaster plays audio files", () async {
    final fakeAudioPlayer = FakeAudioPlayer();
    final fakePermissionProvider = FakePermissionProvider();
    final ghettoBlaster = Mp3GhettoBlaster(
      audioPlayer: fakeAudioPlayer,
      permissionProvider: fakePermissionProvider,
    );
    final playlist = ["a.mp3", "b.mp3"];

    await ghettoBlaster.playAll(playlist);

    expect(fakePermissionProvider.requestWasCalled(), isTrue);
    expect(ghettoBlaster.isPaused(), isFalse);
    expect(ghettoBlaster.hasNext(), isTrue);
    expect(ghettoBlaster.hasPrevious(), isFalse);
  });

  test("Mp3GhettoBlaster plays next audio file", () async {
    final fakeAudioPlayer = FakeAudioPlayer();
    final fakePermissionProvider = FakePermissionProvider();
    final ghettoBlaster = Mp3GhettoBlaster(
      audioPlayer: fakeAudioPlayer,
      permissionProvider: fakePermissionProvider,
    );
    final playlist = ["a.mp3", "b.mp3"];

    await ghettoBlaster.playAll(playlist);
    await ghettoBlaster.next();

    expect(fakePermissionProvider.requestWasCalled(), isTrue);
    expect(ghettoBlaster.isPaused(), isFalse);
    expect(ghettoBlaster.hasNext(), isFalse);
    expect(ghettoBlaster.hasPrevious(), isTrue);
  });
}
