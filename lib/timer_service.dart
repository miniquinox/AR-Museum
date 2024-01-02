// timer_service.dart
import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  Map<String, Duration> _timers = {};
  Map<String, String> _imagePaths = {}; // Store image paths

  void startTimer(String locationId, String imagePath) {
    var timeLeft = Duration(hours: 23, minutes: 59, seconds: 59);
    _timers[locationId] = timeLeft;
    _imagePaths[locationId] = imagePath; // Associate image path

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft.inSeconds > 0) {
        timeLeft -= Duration(seconds: 1);
        _timers[locationId] = timeLeft;
        notifyListeners(); // Important to trigger widget rebuilds
      } else {
        _timers.remove(locationId);
        timer.cancel();
        notifyListeners(); // Notify when timer ends
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

  String? getImagePath(String locationId) {
    return _imagePaths[locationId];
  }

  Map<String, Duration> get activeTimers => _timers;
}
