abstract class AudioEngine {
  Future<void> preload(List<String> assetPaths);
  Future<void> playSound(String assetPath, {double volume = 1.0, String? instrumentId});
  Future<void> stopInstrument(String instrumentId);
  Future<void> stopAll();
  Future<void> dispose();
}