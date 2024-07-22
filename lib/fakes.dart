import 'dart:async';
import 'dart:math';

import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/audiometadata.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/depdencymanager.dart';
import 'package:nfcplayer/interfaces/ghettoblaster.dart';
import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/mappingmanager.dart';
import 'package:nfcplayer/interfaces/nfchandler.dart';

class FakeDepdencyManager extends DepdencyManager {
  final AudioFilePathProvider _audioFilePathProvider =
      FakeAudioFilePathProvider();
  final GhettoBlaster _ghettoBlaster = FakeGhettoBlaster();
  final MappingManager _mappingManager = FakeMappingManager();
  final AudioMetaDataProvider _audioMetaDataProvider =
      FakeAudioMetaDataProvider();
  final NfcHandler _nfcHandler = FakeNfcHandler();

  @override
  Future<DepdencyManager> allocateRessources() async {
    return this;
  }

  @override
  AudioFilePathProvider get audioFilePathProvider => _audioFilePathProvider;

  @override
  GhettoBlaster get ghettoBlaster => _ghettoBlaster;

  @override
  MappingManager get mappingManager => _mappingManager;

  @override
  AudioMetaDataProvider get audioMetaDataProvider => _audioMetaDataProvider;

  @override
  NfcHandler get nfcHandler => _nfcHandler;
}

class FakeAudioFilePathProvider extends AudioFilePathProvider {
  static const List<String> allFiles = [
    "filesystem/Interpret1/Ordner1/Intro",
    "filesystem/Interpret1/Ordner1/Akt 1",
    "filesystem/Interpret1/Ordner1/Akt 2",
    "filesystem/Interpret1/Ordner1/Akt 3",
    "filesystem/Interpret1/Ordner1/Akt 4",
    "filesystem/Interpret1/Ordner1/Akt 5",
    "filesystem/Interpret1/Ordner1/Outro",
    "filesystem/Interpret1/Ordner2/Intro",
    "filesystem/Interpret1/Ordner2/Akt 1",
    "filesystem/Interpret1/Ordner2/Akt 2",
    "filesystem/Interpret1/Ordner2/Akt 3",
    "filesystem/Interpret1/Ordner2/Akt 4",
    "filesystem/Interpret1/Ordner2/Akt 5",
    "filesystem/Interpret1/Ordner2/Outro",
  ];

  @override
  Future<List<String>> listAllAudioFilePaths() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return allFiles;
  }
}

class FakeNfcHandler extends NfcHandler {
  static const tenSeconds = Duration(seconds: 10);
  static const List<String> possibleNfcKeys = [
    "bcdef09876",
    "a82f029dbb",
    "0977bc0def",
  ];

  final List<Future<void> Function(String)> _onNfcKeyDetected = [];

  FakeNfcHandler() {
    Timer.periodic(tenSeconds, _trigger);
  }

  void _trigger(Timer timer) {
    if (_onNfcKeyDetected.isNotEmpty) {
      final nfcKey = possibleNfcKeys[Random().nextInt(possibleNfcKeys.length)];
      for (final element in _onNfcKeyDetected) {
        element(nfcKey);
      }
    }
  }

  @override
  void register(Future<void> Function(NfcKey) onNfcKeyDetected) {
    if (!_onNfcKeyDetected.contains(onNfcKeyDetected)) {
      _onNfcKeyDetected.add(onNfcKeyDetected);
    }
  }

  @override
  void unregister(Future<void> Function(NfcKey) onNfcKeyDetected) {
    _onNfcKeyDetected.remove(onNfcKeyDetected);
  }
}

class FakeMappingManager extends MappingManager {
  Map<String, List<String>> mappings = {
    FakeNfcHandler.possibleNfcKeys[0]: [
      FakeAudioFilePathProvider.allFiles[0],
      FakeAudioFilePathProvider.allFiles[6],
    ],
  };

  @override
  Future<void> add(NfcKey key, Playlist playlist) async {
    mappings[key] = playlist;
  }

  @override
  Future<Playlist> query(NfcKey key) async {
    return mappings[key] ?? [];
  }
}

class FakeGhettoBlaster extends GhettoBlaster {
  bool paused = false;
  int currentTrack = 0;
  int trackListLength = 3;

  @override
  bool hasNext() {
    return currentTrack + 1 < trackListLength;
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
    currentTrack += 1;
  }

  @override
  Future<void> pause() async {
    paused = true;
  }

  @override
  Future<void> playAll(Playlist playlist) async {
    paused = false;
  }

  @override
  Future<void> previous() async {
    currentTrack -= 1;
  }

  @override
  Future<void> resume() async {
    paused = false;
  }

  @override
  void register(Future<void> Function(String) onNextTrack) {}

  @override
  void unregister(Future<void> Function(String) onNextTrack) {}
}

class FakeAudioMetaDataProvider extends AudioMetaDataProvider {
  @override
  Future<AudioMetaData> query(String audioFile) async {
    return AudioMetaData(
      fileName: "/my_location/my_file",
      trackNumber: 1,
      trackName: "song",
      interpret: "interpret",
      album: "album",
    );
  }

  @override
  Future<List<AudioMetaData>> queryList(List<String> audioFiles) async {
    return [await query(audioFiles[0])];
  }
}
