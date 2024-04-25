import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfcplayer/interfaces/audiofilepathprovider.dart';
import 'package:nfcplayer/interfaces/audiometadata.dart';
import 'package:nfcplayer/interfaces/audiometadataprovider.dart';
import 'package:nfcplayer/widgets/audiofilelistview.dart';

class FileSelectionPage extends StatefulWidget {
  final AudioFilePathProvider audioFileProvider;
  final AudioMetaDataProvider aduioMetaDataProvider;

  const FileSelectionPage({
    super.key,
    required this.audioFileProvider,
    required this.aduioMetaDataProvider,
  });

  @override
  State<FileSelectionPage> createState() => _FileSelectionPageState();
}

class _FileSelectionPageState extends State<FileSelectionPage> {
  Set<String> selectedFiles = {};
  int sortOrder = 0;
  String? filter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AudioListEntry>>(
      future: _prepareAudioFileList(),
      builder: (context, snapshot) {
        List<AudioListEntry> availableAudioFiles = (snapshot.hasData &&
                snapshot.data.runtimeType == List<AudioListEntry>)
            ? snapshot.data as List<AudioListEntry>
            : [];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text("Wähle deine Dateien"),
            actions: [
              IconButton(
                padding: const EdgeInsets.all(14.0),
                onPressed: () {
                  Navigator.pop(context, selectedFiles);
                },
                icon: const Icon(Icons.check),
              )
            ],
          ),
          body: Column(
            children: [
              SelectionButtons(
                filters: const ["Album", "Titel"],
                onSelectAll: () => setState(() {
                  selectedFiles.addAll(
                    availableAudioFiles.map((e) => e.filename),
                  );
                }),
                onDeselectAll: () => setState(() {
                  selectedFiles.clear();
                }),
                onChangeFilter: (i) {
                  setState(() {
                    sortOrder = i;
                  });
                },
                onSearchChanged: (s) {
                  setState(() {
                    filter = s;
                  });
                },
              ),
              Expanded(
                child: AudioFileListView(
                  audioFiles: availableAudioFiles,
                  onSelectionChanged: _updateSelectionState,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<AudioListEntry>> _prepareAudioFileList() async {
    List<String> availableAudioFiles =
        await widget.audioFileProvider.listAllAudioFilePaths();
    List<AudioListEntry> visibleAudioFiles = [];
    for (final audioFile in availableAudioFiles) {
      AudioMetaData metaData =
          await widget.aduioMetaDataProvider.query(File(audioFile));
      if (filter != null) {
        final lowerCaseFilter = filter!.toLowerCase();
        if (!metaData.trackName.toLowerCase().contains(lowerCaseFilter) ||
            !metaData.album.toLowerCase().contains(lowerCaseFilter) ||
            !metaData.interpret.toLowerCase().contains(lowerCaseFilter)) {
          continue;
        }
      }
      visibleAudioFiles.add(AudioListEntry(
        title: metaData.trackName,
        album: metaData.album,
        interpret: metaData.interpret,
        filename: audioFile,
        isSelected: selectedFiles.contains(audioFile),
      ));
    }
    visibleAudioFiles.sort(
      (a, b) {
        if (sortOrder == 0) {
          return a.album.compareTo(b.album);
        } else {
          return a.title.compareTo(b.title);
        }
      },
    );
    return visibleAudioFiles;
  }

  void _updateSelectionState(String filename) {
    setState(() {
      if (selectedFiles.contains(filename)) {
        selectedFiles.remove(filename);
      } else {
        selectedFiles.add(filename);
      }
    });
  }
}

class SelectionButtons extends StatefulWidget {
  final List<String> filters;

  final void Function() onSelectAll;
  final void Function() onDeselectAll;
  final void Function(int) onChangeFilter;
  final void Function(String) onSearchChanged;

  const SelectionButtons({
    super.key,
    required this.filters,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onChangeFilter,
    required this.onSearchChanged,
  });

  @override
  State<SelectionButtons> createState() => _SelectionButtonsState();
}

class _SelectionButtonsState extends State<SelectionButtons> {
  int currentFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
            onPressed: widget.onSelectAll,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "Alle auswählen",
                    style: TextStyle(
                      color: Colors.white,
                      fontFeatures: [FontFeature.enable("smcp")],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                currentFilter = (currentFilter + 1) % widget.filters.length;
                widget.onChangeFilter(currentFilter);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "Sortiere nach ${widget.filters[currentFilter]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFeatures: [FontFeature.enable("smcp")],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: widget.onDeselectAll,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "Auswahl aufheben",
                    style: TextStyle(
                      color: Colors.white,
                      fontFeatures: [FontFeature.enable("smcp")],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Suche",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
