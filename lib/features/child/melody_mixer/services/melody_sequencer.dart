import 'dart:async';
import 'melody_recorder.dart';
import 'package:flutter/foundation.dart';

class MelodySequencer {
  final InstrumentPlayer player;
  MelodySequencer(this.player);

  final List<Timer> _timers = [];
  Timer? _endTimer;

  void play(List<RecordedEvent> events, {int durationMs = 0, VoidCallback? onComplete}) {
    stop();
    for (final e in events) {
      _timers.add(Timer(Duration(milliseconds: e.timeMs), () {
        player.playPhrase(e.instrumentId);
      }));
    }
    // poora khatam hone pe
    if (durationMs > 0) {
      _endTimer = Timer(Duration(milliseconds: durationMs), () {
        onComplete?.call();
      });
    }
  }

  void stop() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    _endTimer?.cancel();
    _endTimer = null;
  }
}