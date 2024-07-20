import 'package:flutter/material.dart';
import 'package:nfcplayer/androiddepdencymanager.dart';
import 'package:nfcplayer/interfaces/depdencymanager.dart';
import 'package:nfcplayer/pages/homepage.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const Color spaceCadet = Color.fromARGB(255, 26, 27, 75);
    const Color oxfordBlue = Color.fromARGB(255, 10, 11, 43);
    const Color orangeWeb = Color.fromARGB(255, 247, 164, 0);
    const Color slateGray = Color.fromARGB(255, 125, 132, 145);
    const Color marianBlue = Color.fromARGB(255, 62, 68, 145);

    final depdencyManager = AndroidDepdencyManager();

    return MaterialApp(
      title: "Merlins Geschichtenkasten",
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          background: oxfordBlue,
          primary: spaceCadet,
          onPrimary: orangeWeb,
          onPrimaryContainer: orangeWeb,
          surface: spaceCadet,
          secondary: marianBlue,
          onSecondary: Colors.black,
          onSecondaryContainer: Colors.black,
          tertiary: slateGray,
          onTertiary: Colors.black,
          onTertiaryContainer: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<DepdencyManager>(
        future: depdencyManager.allocateRessources(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(
              nfcManager: snapshot.data!.nfcHandler,
              mappingManager: snapshot.data!.mappingManager,
              audioFileProvider: snapshot.data!.audioFilePathProvider,
              ghettoBlaster: snapshot.data!.ghettoBlaster,
              metaDataProvider: snapshot.data!.audioMetaDataProvider,
            );
          }

          return const Center(
            child: Column(
              children: [
                Text("Initialisiere..."),
              ],
            ),
          );
        },
      ),
    );
  }
}
