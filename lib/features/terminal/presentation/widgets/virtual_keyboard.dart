import 'package:flutter/foundation.dart';
import 'package:xterm/xterm.dart';

class VirtualKeyboard with ChangeNotifier {
  final Terminal terminal;
  bool _ctrl = false;
  bool _alt = false;
  bool _shift = false;
  bool autoResetModifiers = true;

  VirtualKeyboard(this.terminal);

  bool get ctrl => _ctrl;
  bool get alt => _alt;
  bool get shift => _shift;

  void toggleCtrl() {
    _ctrl = !_ctrl;
    notifyListeners();
  }

  void toggleAlt() {
    _alt = !_alt;
    notifyListeners();
  }

  void toggleShift() {
    _shift = !_shift;
    notifyListeners();
  }

  void sendKey(TerminalKey key) {
    terminal.keyInput(
      key,
      ctrl: _ctrl,
      alt: _alt,
      shift: _shift,
    );

    if (autoResetModifiers) {
      _ctrl = false;
      _alt = false;
      _shift = false;
      notifyListeners();
    }
  }

  void sendText(String text) {
    terminal.textInput(text);
  }
}
