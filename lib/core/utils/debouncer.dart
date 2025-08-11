import 'dart:async';
import 'dart:ui';

class Debouncer {
  static final Map<String, Timer> _timers = {};

  static void debounce(String key, VoidCallback action, Duration duration) {
    if (_timers.containsKey(key)) {
      _timers[key]?.cancel();
    }

    _timers[key] = Timer(duration, () {
      action();
      _timers.remove(key);
    });
  }

  static void cancel(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }
}