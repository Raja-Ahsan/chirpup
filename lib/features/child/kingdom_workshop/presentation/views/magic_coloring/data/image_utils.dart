import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageUtils {
  static Future<ui.Image> decodeRgba(
    Uint8List rgba,
    int width,
    int height,
  ) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgba,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image image) => completer.complete(image),
    );
    return completer.future;
  }

  /// Builds a single-purpose alpha mask (RGBA, white where [regionMap] ==
  /// [regionId], transparent everywhere else). Used to clip a bucket-fill
  /// so it only paints inside that one connected region.
  static Uint8List buildRegionMaskRgba(
    Int32List regionMap,
    int width,
    int height,
    int regionId,
  ) {
    final int total = width * height;
    final Uint8List out = Uint8List(total * 4);
    for (int i = 0; i < total; i++) {
      if (regionMap[i] == regionId) {
        final int o = i * 4;
        out[o] = 255;
        out[o + 1] = 255;
        out[o + 2] = 255;
        out[o + 3] = 255;
      }
    }
    return out;
  }

  static Future<ui.Image> decodePng(Uint8List pngBytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(pngBytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<Uint8List> encodePng(ui.Image image) async {
    final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}