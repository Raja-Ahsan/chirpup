import 'dart:async';
import 'package:flutter/foundation.dart';
import 'audio_engine.dart';
import 'beat_clock.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/instrument_patterns.dart';

class InstrumentPlayer {
  final AudioEngine engine;
  final BeatClock clock;
  InstrumentPlayer(this.engine, this.clock);

  final Map<String, int> _session = {};
  final Map<String, int> _patternIndex = {};

  Future<void> playPhrase(
    String instrumentId, {
    VoidCallback? onStart,
    VoidCallback? onEnd,
  }) async {
    final patterns = instrumentPatterns[instrumentId];
    if (patterns == null || patterns.isEmpty) {
      debugPrint('⚠️ NO SOUND for "$instrumentId"');
      return;
    }

    // agla pattern (3 tunes)
    final pIdx = (_patternIndex[instrumentId] ?? -1) + 1;
    _patternIndex[instrumentId] = pIdx;
    final notes = patterns[pIdx % patterns.length];

    final mySession = (_session[instrumentId] ?? 0) + 1;
    _session[instrumentId] = mySession;

    await engine.stopInstrument(instrumentId);
    onStart?.call(); // glow + gif turant (visual feedback), awaaz beat pe

    // 👇 agle beat tak wait — sync ka asli raaz
    await Future.delayed(Duration(milliseconds: clock.msUntilNextBeat()));
    if (_session[instrumentId] != mySession) return;

    // notes ab beat-grid pe (subBeat gap)
    final gap = clock.subBeatMs;
    for (var i = 0; i < notes.length; i++) {
      if (_session[instrumentId] != mySession) return;
      await engine.playSound(notes[i], instrumentId: instrumentId);
      if (i != notes.length - 1) {
        await Future.delayed(Duration(milliseconds: gap));
      }
    }

    final tail = instrumentTailMs[instrumentId] ?? 1000;
    await Future.delayed(Duration(milliseconds: tail));
    await engine.stopInstrument(instrumentId);
    if (_session[instrumentId] == mySession) {
      _session.remove(instrumentId);
      onEnd?.call();
    }
  }
}

// melody_recorder.dart mein — ek simple recorder

class RecordedEvent {
  final int timeMs;
  final String instrumentId;
  const RecordedEvent(this.timeMs, this.instrumentId);
}

class MelodyRecorder {
  final Stopwatch _clock = Stopwatch();
  final List<RecordedEvent> _events = [];

  bool get isRecording => _clock.isRunning;
  int get durationMs =>
      _events.isEmpty ? 0 : _events.last.timeMs + 2000; // tail

  void start() {
    _events.clear();
    _clock
      ..reset()
      ..start();
  }

  void capture(String instrumentId) {
    if (!_clock.isRunning) return;
    _events.add(RecordedEvent(_clock.elapsedMilliseconds, instrumentId));
  }

  List<RecordedEvent> stop() {
    _clock.stop();
    return List.unmodifiable(_events);
  }
}
