import 'dart:typed_data';

class RegionData {
  final int width;
  final int height;
  final Int32List regionMap;
  final int regionCount;
  final Uint8List fillableMaskRgba;
  final Uint8List backgroundMaskRgba;

  const RegionData({
    required this.width,
    required this.height,
    required this.regionMap,
    required this.regionCount,
    required this.fillableMaskRgba,
    required this.backgroundMaskRgba,
  });
  
  int regionAt(int x, int y) {
    if (x < 0 || y < 0 || x >= width || y >= height) return -2;
    return regionMap[y * width + x];
  }
}