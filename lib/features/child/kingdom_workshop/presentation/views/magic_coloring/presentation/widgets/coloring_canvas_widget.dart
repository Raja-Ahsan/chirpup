import 'dart:ui' as ui;
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColoringCanvasWidget extends StatefulWidget {
  const ColoringCanvasWidget({super.key});

  @override
  State<ColoringCanvasWidget> createState() => _ColoringCanvasWidgetState();
}

class _ColoringCanvasWidgetState extends State<ColoringCanvasWidget> {
  Size _lastWidgetSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MagicColoringBloc, MagicColoringStates>(
      builder: (context, state) {
        if (state.regionData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final regionData = state.regionData!;
        final imageSize = Size(regionData.width.toDouble(), regionData.height.toDouble());

        return LayoutBuilder(
          builder: (context, constraints) {
            _lastWidgetSize = Size(constraints.maxWidth, constraints.maxHeight);
            final containRect = _containRect(_lastWidgetSize, imageSize);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: state.isColorPickerActive
                  ? null
                  : (d) => _handleDown(context, d.localPosition, containRect, imageSize, state.selectedTool),
              onPanUpdate: state.isColorPickerActive
                  ? null
                  : (d) => _handleMove(context, d.localPosition, containRect, imageSize, state.selectedTool),
              onPanEnd: state.isColorPickerActive
                  ? null
                  : (_) => _handleUp(context, state.selectedTool),
              onTapUp: (d) => _handleTap(context, d.localPosition, containRect, imageSize, state.selectedTool, state.isColorPickerActive),
              child: Stack(
                children: [
                  CustomPaint(
                    size: _lastWidgetSize,
                    painter: _ColoringPainter(
                      sketchImage: state.sketchImage,
                      bakedLayer: state.bakedLayer,
                      activeStroke: state.activeStroke,
                      glitterTexture: state.glitterTexture,
                      containRect: containRect,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleDown(BuildContext context, Offset local, Rect r, Size s, ColoringToolMode tool) {
    if (tool == ColoringToolMode.bucket) return;
    final p = _mapToImageSpace(local, r, s);
    if (p == null) return;
    context.read<MagicColoringBloc>().add(ColoringStrokeStarted(p));
  }

  void _handleMove(BuildContext context, Offset local, Rect r, Size s, ColoringToolMode tool) {
    if (tool == ColoringToolMode.bucket) return;
    final p = _mapToImageSpace(local, r, s);
    if (p == null) return;
    context.read<MagicColoringBloc>().add(ColoringStrokeExtended(p));
  }

  void _handleUp(BuildContext context, ColoringToolMode tool) {
    if (tool == ColoringToolMode.bucket) return;
    context.read<MagicColoringBloc>().add(const ColoringStrokeEnded());
  }

  void _handleTap(BuildContext context, Offset local, Rect r, Size s, ColoringToolMode tool, bool isColorPickerActive) {
    final p = _mapToImageSpace(local, r, s);

    if (isColorPickerActive) {
      if (p == null) return;
      context.read<MagicColoringBloc>().add(ColoringColorPickedFromCanvas(p));
      return;
    }

    if (tool != ColoringToolMode.bucket) return;

    if (p == null) {
      context.read<MagicColoringBloc>().add(const ColoringBackgroundFillRequested());
      return;
    }
    context.read<MagicColoringBloc>().add(ColoringBucketFillRequested(p));
  }

  Rect _containRect(Size widgetSize, Size imageSize) {
    if (widgetSize.isEmpty || imageSize.isEmpty) return Rect.zero;
    final scale = (widgetSize.width / imageSize.width) < (widgetSize.height / imageSize.height)
        ? widgetSize.width / imageSize.width
        : widgetSize.height / imageSize.height;
    final w = imageSize.width * scale;
    final h = imageSize.height * scale;
    return Rect.fromLTWH((widgetSize.width - w) / 2, (widgetSize.height - h) / 2, w, h);
  }

  Offset? _mapToImageSpace(Offset local, Rect containRect, Size imageSize) {
    if (!containRect.contains(local)) return null;
    final relX = (local.dx - containRect.left) / containRect.width;
    final relY = (local.dy - containRect.top) / containRect.height;
    return Offset(relX * imageSize.width, relY * imageSize.height);
  }
}

class _ColoringPainter extends CustomPainter {
  final ui.Image? sketchImage;
  final ui.Image? bakedLayer;
  final BrushStrokeData? activeStroke;
  final ui.Image? glitterTexture;
  final Rect containRect;

  _ColoringPainter({
    required this.sketchImage,
    required this.bakedLayer,
    required this.activeStroke,
    required this.glitterTexture,
    required this.containRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (containRect == Rect.zero) return;

    if (bakedLayer != null) _drawImageFitted(canvas, bakedLayer!, containRect);

    final stroke = activeStroke;
    if (stroke != null && stroke.points.isNotEmpty) {
      canvas.save();
      canvas.translate(containRect.left, containRect.top);
      final double imgW = sketchImage?.width.toDouble() ?? containRect.width;
      final double imgH = sketchImage?.height.toDouble() ?? containRect.height;
      final scale = containRect.width / imgW;
      canvas.scale(scale);

      if (stroke.isEraser) {
  canvas.saveLayer(Rect.fromLTWH(0, 0, sketchImage?.width.toDouble() ?? 0, sketchImage?.height.toDouble() ?? 0), Paint());

  final erasePreviewPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke.strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  if (stroke.points.length == 1) {
    canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, Paint()..color = Colors.white);
  } else {
    final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (int i = 1; i < stroke.points.length; i++) {
      path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
    }
    canvas.drawPath(path, erasePreviewPaint);
  }

        if (stroke.regionMask != null) {
          canvas.drawImage(
            stroke.regionMask!,
            Offset.zero,
            Paint()
              ..blendMode = BlendMode.dstIn
              ..filterQuality = FilterQuality.none,
          );
        }

        canvas.restore();
      } else {
        final palette = stroke.palette!;

        // 👇 saveLayer add kiya — taake neeche wala regionMask clip
        // (dstIn) sirf isi stroke ke paint pe apply ho, baked layer ko
        // touch na kare
        canvas.saveLayer(Rect.fromLTWH(0, 0, imgW, imgH), Paint());

        final basePaint = Paint()
          ..color = palette.color
          ..blendMode = BlendMode.srcOver
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        Path? path;
        if (stroke.points.length == 1) {
          canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, Paint()..color = palette.color);
        } else {
          path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
          for (int i = 1; i < stroke.points.length; i++) {
            path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
          }
          canvas.drawPath(path, basePaint);
        }

        if (palette.isGlitter && glitterTexture != null) {
          final shader = ui.ImageShader(glitterTexture!, TileMode.repeated, TileMode.repeated, Matrix4.identity().storage);
          final glitterPaint = Paint()
            ..shader = shader
            ..blendMode = BlendMode.screen
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke.strokeWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

          if (stroke.points.length == 1) {
            canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, Paint()..shader = shader..blendMode = BlendMode.screen);
          } else if (path != null) {
            canvas.drawPath(path, glitterPaint);
          }
        }

        // 👇 naya — live-preview ko bhi bake jaisa hi clip karo, taake
        // drag ke dauran hi paint apni shape ke bahar kabhi na jaye
        if (stroke.regionMask != null) {
          canvas.drawImage(
            stroke.regionMask!,
            Offset.zero,
            Paint()
              ..blendMode = BlendMode.dstIn
              ..filterQuality = FilterQuality.none,
          );
        }

        canvas.restore(); // saveLayer ka restore
      }

      canvas.restore();
    }

    if (sketchImage != null) _drawImageFitted(canvas, sketchImage!, containRect);
  }

  void _drawImageFitted(Canvas canvas, ui.Image image, Rect dst) {
    paintImage(
      canvas: canvas,
      rect: dst,
      image: image,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(covariant _ColoringPainter oldDelegate) {
    return oldDelegate.sketchImage != sketchImage ||
        oldDelegate.bakedLayer != bakedLayer ||
        oldDelegate.activeStroke != activeStroke ||
        oldDelegate.glitterTexture != glitterTexture ||
        oldDelegate.containRect != containRect;
  }
}