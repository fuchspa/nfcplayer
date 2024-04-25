import 'package:nfcplayer/interfaces/mapping.dart';

abstract class NfcHandler {
  void register(Future<void> Function(NfcKey) onNfcKeyDetected);
  void unregister(Future<void> Function(NfcKey) onNfcKeyDetected);
}
