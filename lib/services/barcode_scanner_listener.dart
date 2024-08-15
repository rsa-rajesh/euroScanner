import 'dart:async';
import 'package:flutter/services.dart';

typedef BarcodeScannedCallback = void Function(String barcode);

const Duration aSecond = Duration(seconds: 1);
const Duration hundredMs = Duration(milliseconds: 100);
const String lineFeed = '\n';

class BarcodeScannerListener {
  final BarcodeScannedCallback onBarcodeScanned;
  final Duration bufferDuration;
  final bool useKeyDownEvent;
  final bool caseSensitive;

  BarcodeScannerListener({
    /// Callback to be called when barcode is scanned.
    required Function(String) this.onBarcodeScanned,
    required this.bufferDuration,
    required this.useKeyDownEvent,
    required this.caseSensitive,

    /// When experiencing issueswith empty barcodes on Windows,
    /// set this value to true. Default value is `false`.
    // this.useKeyDownEvent = false,

    /// Maximum time between two key events.
    /// If time between two key events is longer than this value
    /// previous keys will be ignored.
  });

  List<String> _scannedChars = [];
  DateTime? _lastScannedCharCodeTime;
  late StreamSubscription<String?> _keyboardSubscription;

  late  StreamController<String?> _controller;
  bool _isShiftPressed = false;
  bool _isListening = false;

  startListener() {
    HardwareKeyboard.instance.addHandler(_keyBoardCallback);
    _controller = StreamController<String?>();
    _keyboardSubscription =
        _controller.stream.where((char) => char != null).listen(onKeyEvent);
    _isListening = true;
  }

  stopListener() {
    _keyboardSubscription.cancel();
    _controller.close();
    HardwareKeyboard.instance.removeHandler(_keyBoardCallback);
    _isListening =false;
  }

  bool isListening(){
    return _isListening;
  }

  void onKeyEvent(String? char) {
    //remove any pending characters older than bufferDuration value
    checkPendingCharCodesToClear();
    _lastScannedCharCodeTime = DateTime.now();
    if (char == lineFeed) {
      onBarcodeScanned.call(_scannedChars.join());
      resetScannedCharCodes();
    } else {
      //add character to list of scanned characters;
      _scannedChars.add(char!);
    }
  }

  void checkPendingCharCodesToClear() {
    if (_lastScannedCharCodeTime != null) {
      if (_lastScannedCharCodeTime!
          .isBefore(DateTime.now().subtract(bufferDuration))) {
        resetScannedCharCodes();
      }
    }
  }

  void resetScannedCharCodes() {
    _lastScannedCharCodeTime = null;
    _scannedChars = [];
  }

  void addScannedCharCode(String charCode) {
    _scannedChars.add(charCode);
  }

  bool _keyBoardCallback(KeyEvent keyEvent) {
    if (keyEvent.logicalKey.keyId > 255 &&
        keyEvent.logicalKey != LogicalKeyboardKey.enter &&
        keyEvent.logicalKey != LogicalKeyboardKey.shiftLeft) return false;
    if ((!useKeyDownEvent && keyEvent is KeyUpEvent) ||
        (useKeyDownEvent && keyEvent is KeyDownEvent)) {
      if (keyEvent is RawKeyEventDataAndroid) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.shiftLeft) {
          _isShiftPressed = true;
        } else {
          if (_isShiftPressed && caseSensitive) {
            _isShiftPressed = false;
            _controller.sink.add(String.fromCharCode(
                    ((keyEvent) as RawKeyEventDataAndroid).codePoint)
                .toUpperCase());
          } else {
            _controller.sink.add(String.fromCharCode(
                ((keyEvent) as RawKeyEventDataAndroid).codePoint));
          }
        }
      }
      else if (keyEvent is RawKeyEventDataFuchsia) {
        _controller.sink.add(String.fromCharCode(
            ((keyEvent) as RawKeyEventDataFuchsia).codePoint));
      }
      else if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        _controller.sink.add(lineFeed);
      }
      else if (keyEvent is RawKeyEventDataWeb) {
        _controller.sink.add(((keyEvent) as RawKeyEventDataWeb).keyLabel);
      }
      else if (keyEvent is RawKeyEventDataLinux) {
        _controller.sink
            .add(((keyEvent) as RawKeyEventDataLinux).keyLabel);
      }
      else if (keyEvent is RawKeyEventDataWindows) {
        _controller.sink.add(String.fromCharCode(
            ((keyEvent) as RawKeyEventDataWindows).keyCode));
      }
      else if (keyEvent is RawKeyEventDataMacOs) {
        _controller.sink
            .add(((keyEvent) as RawKeyEventDataMacOs).characters);
      }
      else if (keyEvent is RawKeyEventDataIos) {
        _controller.sink
            .add(((keyEvent)).character);
      }
      else {
        _controller.sink.add(keyEvent.character);
      }
    }
    return true;
  }
}
