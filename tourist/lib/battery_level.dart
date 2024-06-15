import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryManager extends ChangeNotifier {
  final Battery _battery = Battery();
  int _batteryLevel = 100;

  BatteryManager() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _updateBatteryLevel();
    });
  }

  int get batteryLevel => _batteryLevel;

  Future<void> _updateBatteryLevel() async {
    final batteryLevel = await _battery.batteryLevel;
    if (_batteryLevel != batteryLevel) {
      _batteryLevel = batteryLevel;
      notifyListeners();
    }
  }
}
