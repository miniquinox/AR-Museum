// timer_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'city_data.dart';

class TimerService extends ChangeNotifier {
  Map<String, Duration> _timers = {};
  Map<String, City> _activeCities = {}; // Store active City objects

  void startTimer(City city) {
    final locationId = city.name;
    var timeLeft = Duration(hours: 23, minutes: 59, seconds: 59);
    _timers[locationId] = timeLeft;
    _activeCities[locationId] = city; // Store the City object

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft.inSeconds > 0) {
        timeLeft -= Duration(seconds: 1);
        _timers[locationId] = timeLeft;
        notifyListeners();
      } else {
        _timers.remove(locationId);
        _activeCities.remove(locationId);
        timer.cancel();
        notifyListeners();
      }
    });
  }

  String getFormattedTimeLeft(String locationId) {
    final timeLeft = _timers[locationId];
    if (timeLeft != null) {
      return '${timeLeft.inHours}:${(timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '00:00:00';
  }

  bool isPurchaseComplete(String locationId) {
    return _timers.containsKey(locationId);
  }

  Duration? getTimeLeft(String locationId) {
    return _timers[locationId];
  }

  City? getCity(String locationId) {
    return _activeCities[locationId];
  }

  Map<String, Duration> get activeTimers => _timers;
}
