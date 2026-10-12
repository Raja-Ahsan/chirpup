import 'package:flutter_soloud/flutter_soloud.dart';
import 'audio_engine.dart';

class SoLoudAudioEngine implements AudioEngine {
  final _soloud = SoLoud.instance;
  final Map<String, AudioSource> _sources = {};
  // har instrument ke current bajte handles (band karne ke liye)
  final Map<String, List<SoundHandle>> _handles = {};
  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    await _soloud.init();
    _ready = true;
  }

  @override
  Future<void> preload(List<String> assetPaths) async {
    await _init();
    for (final path in assetPaths) {
      if (_sources.containsKey(path)) continue;
      try {
        _sources[path] = await _soloud.loadAsset(path);
      } catch (_) {}
    }
  }

  @override
  Future<void> playSound(String assetPath, {double volume = 1.0, String? instrumentId}) async {
    final src = _sources[assetPath];
    if (src == null) return;
    final handle = _soloud.play(src, volume: volume);
    if (instrumentId != null) {
      (_handles[instrumentId] ??= []).add(handle);
    }
  }

  @override
  Future<void> stopInstrument(String instrumentId) async {
    final list = _handles[instrumentId];
    if (list == null) return;
    for (final h in list) {
      _soloud.stop(h);   // purani awaaz band
    }
    list.clear();
  }

  @override
  Future<void> stopAll() async => _soloud.disposeAllSources();

  @override
  Future<void> dispose() async {
    for (final s in _sources.values) {
      await _soloud.disposeSource(s);
    }
    _sources.clear();
    _handles.clear();
    _soloud.deinit();
    _ready = false;
  }
}