import 'package:flutter/material.dart';

class AudioListEntry {
  final String title;
  final String album;
  final String interpret;
  final String filename;
  final bool isSelected;

  AudioListEntry({
    required this.title,
    required this.album,
    required this.interpret,
    required this.filename,
    required this.isSelected,
  });
}

class AudioFileListView extends StatelessWidget {
  final List<AudioListEntry> audioFiles;
  final Function(String) onSelectionChanged;

  const AudioFileListView({
    super.key,
    required this.audioFiles,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (audioFiles.isEmpty) {
      return const Center(
        child: Text("Durchsuche das Dateisystem..."),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: audioFiles.length,
        separatorBuilder: (context, index) {
          return Divider(
            indent: 5.0,
            endIndent: 5.0,
            color: Theme.of(context).colorScheme.primary,
          );
        },
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(audioFiles[index].title),
            subtitle: Text(audioFiles[index].album),
            onLongPress: () {
              onSelectionChanged(audioFiles[index].filename);
            },
            leading: const CircleAvatar(
              child: Icon(
                Icons.music_note,
                color: Colors.grey,
              ),
            ),
            trailing: Checkbox(
              value: audioFiles[index].isSelected,
              onChanged: (value) {
                onSelectionChanged(audioFiles[index].filename);
              },
            ),
          );
        },
      ),
    );
  }
}
