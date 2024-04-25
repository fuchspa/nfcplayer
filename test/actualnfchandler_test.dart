import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfcplayer/actualnfchandler.dart';
import 'package:test/test.dart';

class FakeNfcManager implements NfcManager {
  final List<int> identifier;

  FakeNfcManager(this.identifier);

  @override
  Future<bool> isAvailable() async {
    return true;
  }

  @override
  Future<void> startSession({
    required NfcTagCallback onDiscovered,
    Set<NfcPollingOption>? pollingOptions,
    String? alertMessage,
    bool? invalidateAfterFirstRead = true,
    NfcErrorCallback? onError,
  }) async {
    onDiscovered(
      NfcTag(
        handle: "",
        data: {
          "ndefformatbale": {
            "identifier": identifier,
          },
        },
      ),
    );
  }

  @override
  Future<void> stopSession({
    String? alertMessage,
    String? errorMessage,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test("NFC handler yields md5 checksum", () async {
    final tagData = [87, 12, 87, 140];
    final nfcManager = FakeNfcManager(tagData);

    await ActualNfcHandler.allocateResource(nfcManager);
  });
}
