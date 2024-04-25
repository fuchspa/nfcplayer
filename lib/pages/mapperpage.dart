import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/interfaces/mappingmanager.dart';
import 'package:nfcplayer/interfaces/nfchandler.dart';
import 'package:nfcplayer/pages/fileselectionpage.dart';

class MapperPage extends StatefulWidget {
  final NfcHandler nfcManager;
  final MappingManager mappingManager;
  final AudioFilePathProvider audioFileProvider;
  final AudioMetaDataProvider aduioMetaDataProvider;

  const MapperPage({
    super.key,
    required this.nfcManager,
    required this.mappingManager,
    required this.audioFileProvider,
    required this.aduioMetaDataProvider,
  });

  @override
  State<MapperPage> createState() => _MapperPageState();
}

class _MapperPageState extends State<MapperPage> {
  List<String> selectedFiles = [];
  String? selectedMarker;

  @override
  Widget build(BuildContext context) {
    widget.nfcManager.register(_onNfcKeyDetected);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geschichtenverwaltung"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.all(24.0),
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: SizedBox(
                  width: 192,
                  height: 192,
                  child: Center(
                    child: selectedMarker == null
                        ? const Text("Lese einen Marker ein.")
                        : Icon(
                            selectedFiles.isEmpty
                                ? Icons.music_note_outlined
                                : Icons.music_note,
                            size: 192.0,
                            color: selectedFiles.isEmpty
                                ? Colors.grey[600]
                                : Colors.white,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListTile(
                enabled: selectedMarker != null,
                tileColor: Theme.of(context).colorScheme.tertiary,
                onTap: () {
                  _navigateToFileSelection(context);
                },
                title: Text(
                  "Hinzufügen",
                  style: TextStyle(
                    fontFeatures: const [FontFeature.enable("smcp")],
                    fontWeight: FontWeight.bold,
                    color: selectedMarker == null
                        ? Colors.grey[850]
                        : Theme.of(context).colorScheme.background,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: selectedMarker == null
                        ? Colors.grey[850]
                        : Theme.of(context).colorScheme.background,
                  ),
                  onPressed: selectedMarker == null
                      ? null
                      : () {
                          _navigateToFileSelection(context);
                        },
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
              itemCount: selectedFiles.length,
              itemBuilder: (context, index) {
                final filename = selectedFiles[index];
                final parts = filename.split("/");
                return ListTile(
                  tileColor: index % 2 == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  title: Text(parts[parts.length - 1]),
                  subtitle: Text(parts[parts.length - 2]),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _remove(filename),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _remove(String filename) async {
    if (!mounted) {
      return;
    }

    final selectedNfcKey = selectedMarker!;
    final selectedPlaylist = selectedFiles;
    selectedPlaylist.remove(filename);

    setState(() {
      selectedFiles = selectedPlaylist;
    });

    await widget.mappingManager.add(selectedNfcKey, selectedPlaylist);
  }

  Future<void> _onNfcKeyDetected(String tag) async {
    if (!mounted) {
      return;
    }

    final selectedPlaylist = await widget.mappingManager.query(tag);

    setState(() {
      selectedMarker = tag;
      selectedFiles = selectedPlaylist;
    });
  }

  Future<void> _navigateToFileSelection(BuildContext context) async {
    widget.nfcManager.unregister(_onNfcKeyDetected);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileSelectionPage(
          audioFileProvider: widget.audioFileProvider,
          aduioMetaDataProvider: widget.aduioMetaDataProvider,
        ),
      ),
    );

    if (!mounted || result == null || result is List<String>) {
      return;
    }

    widget.nfcManager.register(_onNfcKeyDetected);

    final selectedNfcKey = selectedMarker!;
    final selectedPlaylist = selectedFiles;
    selectedPlaylist.addAll(result);

    setState(() {
      selectedFiles = selectedPlaylist;
    });

    await widget.mappingManager.add(selectedNfcKey, selectedPlaylist);
  }
}
