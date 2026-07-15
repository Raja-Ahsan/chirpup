import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'region_data.dart';

class RegionProcessor {
  static Future<RegionData> process(Uint8List sketchPngBytes) {
    return compute(_process, sketchPngBytes);
  }

  static RegionData _process(Uint8List bytes) {
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('RegionProcessor: could not decode sketch image');
    }

    final int width = decoded.width;
    final int height = decoded.height;
    final int total = width * height;

    // ---- 1. classify dark OPAQUE outline pixels ----
    const int luminanceThreshold = 150;
    const int alphaThreshold = 25;

    final List<bool> isLine = List<bool>.filled(total, false);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final img.Pixel p = decoded.getPixel(x, y);
        final int r = p.r.toInt();
        final int g = p.g.toInt();
        final int b = p.b.toInt();
        final int a = p.a.toInt();
        final double luminance = 0.299 * r + 0.587 * g + 0.114 * b;
        isLine[y * width + x] = a > alphaThreshold && luminance < luminanceThreshold;
      }
    }

    // ---- 2. dilate line mask by 2px — sirf boundary-fill ke liye ----
    const int dilateRadius = 2;
    final List<bool> dilatedLine = List<bool>.from(isLine);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (!isLine[y * width + x]) continue;
        for (int dy = -dilateRadius; dy <= dilateRadius; dy++) {
          for (int dx = -dilateRadius; dx <= dilateRadius; dx++) {
            final int nx = x + dx;
            final int ny = y + dy;
            if (nx < 0 || ny < 0 || nx >= width || ny >= height) continue;
            dilatedLine[ny * width + nx] = true;
          }
        }
      }
    }

    // ---- 3. boundary flood-fill: edges se background detect karo ----
    final List<bool> isOutsideBackground = List<bool>.filled(total, false);
    final Int32List boundaryQueue = Int32List(total);
    int bHead = 0, bTail = 0;

    void trySeed(int idx) {
      if (!dilatedLine[idx] && !isOutsideBackground[idx]) {
        isOutsideBackground[idx] = true;
        boundaryQueue[bTail++] = idx;
      }
    }

    for (int x = 0; x < width; x++) {
      trySeed(x);
      trySeed((height - 1) * width + x);
    }
    for (int y = 0; y < height; y++) {
      trySeed(y * width);
      trySeed(y * width + (width - 1));
    }

    while (bHead < bTail) {
      final int idx = boundaryQueue[bHead++];
      final int x = idx % width;
      final int y = idx ~/ width;

      if (x > 0) trySeed(idx - 1);
      if (x < width - 1) trySeed(idx + 1);
      if (y > 0) trySeed(idx - width);
      if (y < height - 1) trySeed(idx + width);
    }

    // ---- 4. blocked mask (line OR background) — interior detect karne ke liye ----
    final List<bool> isBlocked = List<bool>.filled(total, false);
    for (int i = 0; i < total; i++) {
      isBlocked[i] = isLine[i] || isOutsideBackground[i];
    }

    // ---- 5. masks banao: interior-fillable + background-fillable, alag alag ----
    const int backgroundRegionId = -2; // 👈 background ka reserved sentinel id
    final Uint8List fillableMaskRgba = Uint8List(total * 4);
    final Uint8List backgroundMaskRgba = Uint8List(total * 4);
    final Int32List regionMap = Int32List(total)..fillRange(0, total, -1);

    for (int i = 0; i < total; i++) {
      final int o = i * 4;
      if (isOutsideBackground[i]) {
        // background — apna alag mask + apna region id
        regionMap[i] = backgroundRegionId;
        backgroundMaskRgba[o] = 255;
        backgroundMaskRgba[o + 1] = 255;
        backgroundMaskRgba[o + 2] = 255;
        backgroundMaskRgba[o + 3] = 255;
      } else if (!isLine[i]) {
        // interior fillable (line bhi nahi, background bhi nahi)
        fillableMaskRgba[o] = 255;
        fillableMaskRgba[o + 1] = 255;
        fillableMaskRgba[o + 2] = 255;
        fillableMaskRgba[o + 3] = 255;
      }
      // isLine[i] == true wale pixels dono masks mein alpha 0 hi rahenge (permanently blocked)
    }

    // ---- 6. flood-fill label every connected INTERIOR fillable blob ----
    final Int32List queue = Int32List(total);
    int nextRegionId = 0;

    for (int start = 0; start < total; start++) {
      if (isBlocked[start] || regionMap[start] != -1) continue;

      int head = 0, tail = 0;
      queue[tail++] = start;
      regionMap[start] = nextRegionId;

      while (head < tail) {
        final int idx = queue[head++];
        final int x = idx % width;
        final int y = idx ~/ width;

        if (x > 0) {
          final int n = idx - 1;
          if (!isBlocked[n] && regionMap[n] == -1) {
            regionMap[n] = nextRegionId;
            queue[tail++] = n;
          }
        }
        if (x < width - 1) {
          final int n = idx + 1;
          if (!isBlocked[n] && regionMap[n] == -1) {
            regionMap[n] = nextRegionId;
            queue[tail++] = n;
          }
        }
        if (y > 0) {
          final int n = idx - width;
          if (!isBlocked[n] && regionMap[n] == -1) {
            regionMap[n] = nextRegionId;
            queue[tail++] = n;
          }
        }
        if (y < height - 1) {
          final int n = idx + width;
          if (!isBlocked[n] && regionMap[n] == -1) {
            regionMap[n] = nextRegionId;
            queue[tail++] = n;
          }
        }
      }
      nextRegionId++;
    }

    return RegionData(
      width: width,
      height: height,
      regionMap: regionMap,
      regionCount: nextRegionId,
      fillableMaskRgba: fillableMaskRgba,
      backgroundMaskRgba: backgroundMaskRgba,
    );
  }
}