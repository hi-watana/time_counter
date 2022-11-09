library time_counter_flutter_library;

import 'package:flutter/material.dart';

class BannerAdHeightHolder extends ChangeNotifier {
  int? _adHeight;

  int? getAdHeight() {
    return _adHeight;
  }

  void setAdHeight(int height) {
    _adHeight = height;
    notifyListeners();
  }
}
