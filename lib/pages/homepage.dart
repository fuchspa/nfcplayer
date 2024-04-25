import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/ghettoblaster.dart';
import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/mappingmanager.dart';
import 'package:nfcplayer/interfaces/nfchandler.dart';
import 'package:nfcplayer/pages/mapperpage.dart';

class HomePage extends StatefulWidget {
  final NfcHandler nfcManager;
  final MappingManager mappingManager;
  final AudioFilePathProvider audioFileProvider;
  final GhettoBlaster ghettoBlaster;
  final AudioMetaDataProvider metaDataProvider;

  const HomePage({
    super.key,
    required this.nfcManager,
    required this.mappingManager,
    required this.audioFileProvider,
    required this.ghettoBlaster,
    required this.metaDataProvider,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Playlist? selectedPlaylist;
  String? selectedMarker;
  Image? albumArt;

  Future<void> _handleNfcTagRead(String tag) async {
    if (!mounted) {
      return;
    }

    final playlist = await widget.mappingManager.query(tag);
    if (playlist.isEmpty) {
      return;
    }

    setState(() {
      selectedMarker = tag;
      selectedPlaylist = playlist;
    });

    await widget.ghettoBlaster.playAll(playlist);
  }

  Future<void> _handleTrackChange(String track) async {
    final metadata = await widget.metaDataProvider.query(File(track));

    setState(() {
      albumArt = metadata.albumCover != null
          ? Image.memory(
              metadata.albumCover!,
              width: 192,
              height: 192,
            )
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.nfcManager.register(_handleNfcTagRead);
    widget.ghettoBlaster.register(_handleTrackChange);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merlins Geschichtenkasten"),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 2),
            AlbumCoverWidget(
              isActive: selectedMarker != null,
              albumArt: albumArt,
            ),
            const Spacer(flex: 2),
            AudioPlayerWidget(
              selectedPlaylist:
                  selectedPlaylist != null ? selectedPlaylist! : [],
              ghettoBlaster: widget.ghettoBlaster,
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMapper(context),
        tooltip: "Einstellungen",
        child: Icon(
          Icons.settings,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }

  Future<void> _navigateToMapper(BuildContext context) async {
    widget.nfcManager.unregister(_handleNfcTagRead);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapperPage(
          nfcManager: widget.nfcManager,
          mappingManager: widget.mappingManager,
          audioFileProvider: widget.audioFileProvider,
          aduioMetaDataProvider: widget.metaDataProvider,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    widget.nfcManager.register(_handleNfcTagRead);
  }
}

class AlbumCoverWidget extends StatelessWidget {
  final bool isActive;
  final Image? albumArt;

  const AlbumCoverWidget({
    super.key,
    required this.isActive,
    this.albumArt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: isActive
            ? SizedBox(
                width: 192,
                height: 192,
                child: albumArt ??
                    const Icon(
                      Icons.music_note,
                      size: 192,
                    ),
              )
            : const SizedBox(
                width: 192,
                height: 192,
                child: Center(
                  child: Text("Was möchtest du hören?"),
                ),
              ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final GhettoBlaster ghettoBlaster;
  final Playlist selectedPlaylist;

  const AudioPlayerWidget({
    super.key,
    required this.selectedPlaylist,
    required this.ghettoBlaster,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late bool hasPrevious;
  late bool hasNext;
  late bool isPaused;

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  void _updateState() {
    hasPrevious = widget.ghettoBlaster.hasPrevious();
    hasNext = widget.ghettoBlaster.hasNext();
    isPaused = widget.ghettoBlaster.isPaused();
  }

  @override
  Widget build(BuildContext context) {
    widget.ghettoBlaster.register(
      (track) async {
        setState(() {
          _updateState();
        });
      },
    );
    return Row(
      children: [
        const Spacer(),
        ElevatedButton(
          onPressed: hasPrevious
              ? () async => await widget.ghettoBlaster.previous()
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: const Size(80, 80),
          ),
          child: Icon(
            Icons.skip_previous,
            color: hasPrevious
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.background,
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            if (widget.ghettoBlaster.isPaused()) {
              await widget.ghettoBlaster.resume();
            } else {
              await widget.ghettoBlaster.pause();
            }
            setState(() {
              isPaused = widget.ghettoBlaster.isPaused();
            });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: const Size(120, 120),
          ),
          child: Icon(
            isPaused ? Icons.play_arrow : Icons.pause,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 40.0,
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed:
              hasNext ? () async => await widget.ghettoBlaster.next() : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: const Size(80, 80),
          ),
          child: Icon(
            Icons.skip_next,
            color: hasNext
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.background,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
