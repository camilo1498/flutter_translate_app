import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  bool _isPanelOpen = false;
  bool get isPanelOpen => _isPanelOpen;
  set isPanelOpen(bool open) {
    _isPanelOpen = open;
    notifyListeners();
  }

  double _opacity = 0.0;
  double get opacity => _opacity;
  set opacity(double value) {
    _opacity = value;
    notifyListeners();
  }

  double _opacityHistory = 1.0;
  double get opacityHistory => _opacityHistory;
  set opacityHistory(double value) {
    _opacityHistory = value;
    notifyListeners();
  }
}
