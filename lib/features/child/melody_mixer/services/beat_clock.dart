import 'dart:async';

class BeatClock {
  final int bpm;          // tempo — 100 bpm = har beat 600ms
  late final int beatMs;
  Timer? _ticker;
  int _beatCount = 0;
  DateTime? _startTime;

  BeatClock({this.bpm = 100}) {
    beatMs = (60000 / bpm).round();   // ek beat ki duration
  }

  void start() {
    _startTime = DateTime.now();
    _beatCount = 0;
    _ticker = Timer.periodic(Duration(milliseconds: beatMs), (_) {
      _beatCount++;
    });
  }

  /// Agle beat tak kitni der hai (ms). Tap ko isse snap karte hain.
  int msUntilNextBeat() {
    if (_startTime == null) return 0;
    final elapsed = DateTime.now().difference(_startTime!).inMilliseconds;
    final intoBeat = elapsed % beatMs;
    return beatMs - intoBeat;   // agle beat tak bacha hua waqt
  }

  int get subBeatMs => beatMs ~/ 2;   // aadha beat (notes ke beech gap)

  void stop() {
    _ticker?.cancel();
    _ticker = null;
    _startTime = null;
  }
}