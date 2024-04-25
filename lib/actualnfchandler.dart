import 'package:crypto/crypto.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfcplayer/interfaces/mapping.dart';
import 'package:nfcplayer/interfaces/nfchandler.dart';

class ActualNfcHandler extends NfcHandler {
  static const _dataFormat = "ndefformatable";
  static const _key = "identifier";

  final NfcManager nfcManager;
  final List<Future<void> Function(String)> _onNfcKeyDetected = [];

  ActualNfcHandler._(this.nfcManager);

  Future<void> _initialize() async {
    if (await nfcManager.isAvailable()) {
      nfcManager.startSession(
        onDiscovered: _handleNfcTag,
      );
    }
  }

  static Future<NfcHandler> allocateResource(NfcManager nfcManager) async {
    final nfcHandler = ActualNfcHandler._(nfcManager);
    await nfcHandler._initialize();
    return nfcHandler;
  }

  Future<void> _handleNfcTag(NfcTag tag) async {
    if (!_properTag(tag)) {
      return;
    }

    final nfcKey = md5.convert(tag.data[_dataFormat][_key]).toString();

    for (final element in _onNfcKeyDetected) {
      element(nfcKey);
    }
  }

  bool _properTag(NfcTag tag) {
    return tag.data.containsKey(_dataFormat) &&
        tag.data[_dataFormat].containsKey(_key);
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
