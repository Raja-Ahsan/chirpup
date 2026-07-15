import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui' as ui;
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/glitter_texture_factory.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/image_utils.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/region_processor.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/repositories/magic_coloring_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';

const double kBrushStrokeWidth = 22;
const double kEraserStrokeWidth = 34;
const int kBackgroundRegionId = -2;

class MagicColoringBloc extends Bloc<MagicColoringEvent, MagicColoringStates> {
  final DummyMagicColoringRepository repository = DummyMagicColoringRepository();
  final Map<int, ui.Image> _regionMaskCache = {};

  MagicColoringBloc() : super(const MagicColoringStates()) {
    on<MagicColoringStarted>(_onStarted);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<SketchesForBookRequested>(_onSketchesForBookRequested);
    on<SketchCategorySelected>(_onSketchCategorySelected);

    on<ColoringImageLoaded>(_onImageLoaded);
    on<ColoringToolChanged>(_onToolChanged);
    on<ColoringColorSelected>(_onColorSelected);
    on<ColoringBrushSizeChanged>(_onBrushSizeChanged);
    on<ColoringStrokeStarted>(_onStrokeStarted);
    on<ColoringStrokeExtended>(_onStrokeExtended);
    on<ColoringStrokeEnded>(_onStrokeEnded);
    on<ColoringBucketFillRequested>(_onBucketFillRequested);
    on<ColoringBackgroundFillRequested>(_onBackgroundFillRequested);
    on<ColoringCleared>(_onColoringCleared);
    on<ColoringSaveRequested>(_onSaveRequested);
    on<ColoringColorPickerToggled>(_onColorPickerToggled);
    on<ColoringColorPickedFromCanvas>(_onColorPickedFromCanvas);

    on<MyDrawingsRequested>(_onMyDrawingsRequested);
    on<MyDrawingDeleteRequested>(_onMyDrawingDeleteRequested);
  }

  // ══════════ session/catalog handlers ══════════
  Future<void> _onStarted(MagicColoringStarted event, Emitter<MagicColoringStates> emit) async {
    emit(state.copyWith(isLoading: true, childId: event.childId, characterId: event.characterId));
    try {
      final seen = await repository.hasSeenOnboarding(event.childId);
      final ageGroup = await repository.getAgeGroup(event.childId);
      emit(state.copyWith(isLoading: false, hasSeenOnboarding: seen, ageGroup: ageGroup));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onOnboardingCompleted(OnboardingCompleted event, Emitter<MagicColoringStates> emit) async {
    await repository.markOnboardingSeen(state.childId);
    emit(state.copyWith(hasSeenOnboarding: true));
  }

  Future<void> _onSketchesForBookRequested(SketchesForBookRequested event, Emitter<MagicColoringStates> emit) async {
    emit(state.copyWith(isSketchesLoading: true));
    try {
      final categories = await repository.getSketchCategories(event.bookId);
      final sketches = await repository.getSketches(event.bookId);
      emit(state.copyWith(
        isSketchesLoading: false,
        sketchCategories: categories,
        sketches: sketches,
        selectedCategoryId: categories.isNotEmpty ? categories.first.id : null,
      ));
    } catch (e) {
      emit(state.copyWith(isSketchesLoading: false, errorMessage: e.toString()));
    }
  }

  void _onSketchCategorySelected(SketchCategorySelected event, Emitter<MagicColoringStates> emit) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }

  Future<void> _onMyDrawingsRequested(
    MyDrawingsRequested event,
    Emitter<MagicColoringStates> emit,
  ) async {
    emit(state.copyWith(isMyDrawingsLoading: true));
    try {
      final drawings = await repository.getMyDrawings(event.childId);
      emit(state.copyWith(isMyDrawingsLoading: false, myDrawings: drawings));
    } catch (e) {
      emit(
        state.copyWith(isMyDrawingsLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onMyDrawingDeleteRequested(
    MyDrawingDeleteRequested event,
    Emitter<MagicColoringStates> emit,
  ) async {
    await repository.deleteMyDrawing(event.drawingId);
    final updated = state.myDrawings
        .where((d) => d.id != event.drawingId)
        .toList();
    emit(state.copyWith(myDrawings: updated));
  }

  // ══════════ Coloring canvas handlers ══════════

  Future<void> _onImageLoaded(ColoringImageLoaded event, Emitter<MagicColoringStates> emit) async {
  emit(state.copyWith(
    canvasStatus: ColoringCanvasStatus.processingRegions,
    currentSketchId: event.sketchId,
    clearBakedLayer: true,
    regionColors: {},
    clearBackgroundPalette: true,
  ));
  try {
    final bytes = (await rootBundle.load(event.assetPath)).buffer.asUint8List();
    final regionData = await RegionProcessor.process(bytes);
    final sketchImage = await ImageUtils.decodePng(bytes);
    final fillableMask = await ImageUtils.decodeRgba(
      regionData.fillableMaskRgba,
      regionData.width,
      regionData.height,
    );
    final backgroundMask = await ImageUtils.decodeRgba(
      regionData.backgroundMaskRgba,
      regionData.width,
      regionData.height,
    );
    final glitterTexture = state.glitterTexture ?? await GlitterTextureFactory.build();

    _regionMaskCache.clear();

    emit(state.copyWith(
      canvasStatus: ColoringCanvasStatus.ready,
      regionData: regionData,
      sketchImage: sketchImage,
      fillableMask: fillableMask,
      backgroundMask: backgroundMask,
      glitterTexture: glitterTexture,
    ));

    // 👇 naya — pehle se saved progress ho to load karo
    final progress = await repository.loadColoringProgress(
      childId: state.childId,
      sketchId: event.sketchId,
    );

    if (progress != null) {
      final restoredImage = await _decodeStoredImage(progress.coloredImageUrl);
      if (restoredImage != null) {
        emit(state.copyWith(
          bakedLayer: restoredImage,
          regionColors: progress.regionColors,
          backgroundPalette: progress.backgroundPalette,
        ));
      }
    }
  } catch (e) {
    emit(state.copyWith(canvasStatus: ColoringCanvasStatus.error, canvasErrorMessage: e.toString()));
  }
}

Future<ui.Image?> _decodeStoredImage(String urlOrData) async {
  if (urlOrData.startsWith('local://')) {
    final base64Data = urlOrData.substring('local://'.length);
    final bytes = base64Decode(base64Data);
    return await ImageUtils.decodePng(bytes);
  }
  // real API case (future): network se download karke decode karo
  return null;
}

  void _onToolChanged(ColoringToolChanged event, Emitter<MagicColoringStates> emit) {
    PaletteColor palette = state.selectedPalette;

    if (event.tool == ColoringToolMode.glitterPen && !state.selectedPalette.isGlitter) {
      palette = ColoringPalettes.glitter.first;
    } else if (event.tool != ColoringToolMode.glitterPen && state.selectedPalette.isGlitter) {
      palette = ColoringPalettes.normal.first;
    }

    emit(state.copyWith(selectedTool: event.tool, selectedPalette: palette));
  }

  void _onColorSelected(ColoringColorSelected event, Emitter<MagicColoringStates> emit) {
    emit(state.copyWith(selectedPalette: event.palette));
  }

  void _onBrushSizeChanged(ColoringBrushSizeChanged event, Emitter<MagicColoringStates> emit) {
    emit(state.copyWith(brushSize: event.size));
  }

  void _onColorPickerToggled(ColoringColorPickerToggled event, Emitter<MagicColoringStates> emit) {
    emit(state.copyWith(isColorPickerActive: !state.isColorPickerActive));
  }

  Future<void> _onColorPickedFromCanvas(
  ColoringColorPickedFromCanvas event,
  Emitter<MagicColoringStates> emit,
) async {
  final regionData = state.regionData;
  if (regionData == null) {
    emit(state.copyWith(isColorPickerActive: false));
    return;
  }

  final rx = event.point.dx.round();
  final ry = event.point.dy.round();
  final regionId = regionData.regionAt(rx, ry);

  if (regionId == -1) {
    emit(state.copyWith(isColorPickerActive: false));
    return;
  }

  final baked = state.bakedLayer;
  if (baked == null) {
    emit(state.copyWith(isColorPickerActive: false));
    return;
  }

  final byteData = await baked.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) {
    emit(state.copyWith(isColorPickerActive: false));
    return;
  }

  const int radius = 3;
  final List<int> rSamples = [];
  final List<int> gSamples = [];
  final List<int> bSamples = [];
  bool anyOpaque = false;

  for (int dy = -radius; dy <= radius; dy++) {
    for (int dx = -radius; dx <= radius; dx++) {
      final int sx = (rx + dx).clamp(0, regionData.width - 1);
      final int sy = (ry + dy).clamp(0, regionData.height - 1);
      final int idx = (sy * regionData.width + sx) * 4;
      final int a = byteData.getUint8(idx + 3);
      if (a < 40) continue; 
      anyOpaque = true;
      rSamples.add(byteData.getUint8(idx));
      gSamples.add(byteData.getUint8(idx + 1));
      bSamples.add(byteData.getUint8(idx + 2));
    }
  }

  if (!anyOpaque || rSamples.isEmpty) {
    emit(state.copyWith(isColorPickerActive: false));
    return;
  }

  // average color nikaalo
  final double avgR = rSamples.reduce((a, b) => a + b) / rSamples.length;
  final double avgG = gSamples.reduce((a, b) => a + b) / gSamples.length;
  final double avgB = bSamples.reduce((a, b) => a + b) / bSamples.length;

  // variance nikaalo — glitter mein sparkle-specks ki wajah se
  double variance = 0;
  for (int i = 0; i < rSamples.length; i++) {
    final dr = rSamples[i] - avgR;
    final dg = gSamples[i] - avgG;
    final db = bSamples[i] - avgB;
    variance += (dr * dr + dg * dg + db * db);
  }
  variance /= rSamples.length;

  const double glitterVarianceThreshold = 250;
  final bool looksLikeGlitter = variance > glitterVarianceThreshold;

  debugPrint('PICKER: avg=($avgR,$avgG,$avgB) variance=$variance looksLikeGlitter=$looksLikeGlitter');

  final avgColor = Color.fromARGB(255, avgR.round(), avgG.round(), avgB.round());

  final candidateList = looksLikeGlitter ? ColoringPalettes.glitter : ColoringPalettes.normal;

  PaletteColor? closest;
  int bestDistance = 1 << 30;
  for (final p in candidateList) {
    final dr = p.color.red - avgColor.red;
    final dg = p.color.green - avgColor.green;
    final db = p.color.blue - avgColor.blue;
    final distance = dr * dr + dg * dg + db * db;
    if (distance < bestDistance) {
      bestDistance = distance;
      closest = p;
    }
  }

  debugPrint('PICKER: FINAL MATCH = ${closest?.id}, isGlitter=${closest?.isGlitter}');

  final matchedTool = looksLikeGlitter ? ColoringToolMode.glitterPen : ColoringToolMode.brush;

  emit(state.copyWith(
    isColorPickerActive: false,
    selectedPalette: closest ?? state.selectedPalette,
    selectedTool: matchedTool,
  ));
}

  Future<void> _onStrokeStarted(ColoringStrokeStarted event, Emitter<MagicColoringStates> emit) async {
  final regionData = state.regionData;
  if (regionData == null) return;

  final rx = event.point.dx.round();
  final ry = event.point.dy.round();
  final regionId = regionData.regionAt(rx, ry);
  if (regionId == -1) return;

  final isEraser = state.selectedTool == ColoringToolMode.eraser;

  ui.Image? domainMask;
  if (isEraser) {
    domainMask = regionId == kBackgroundRegionId
        ? state.backgroundMask
        : state.fillableMask;
  } else {
    domainMask = regionId == kBackgroundRegionId
        ? state.backgroundMask
        : await _getOrBuildRegionMask(regionData, regionId);
  }

  final stroke = BrushStrokeData(
    points: [event.point],
    palette: isEraser ? null : state.selectedPalette,
    strokeWidth: state.brushSize,
    isEraser: isEraser,
    regionId: regionId,
    regionMask: domainMask,
  );
  emit(state.copyWith(activeStroke: stroke));
}

  // 👇 FIX: koi bhi per-point region check nahi — path kabhi freeze nahi hoga.
  // Bleed-protection ab bake-time pe per-region mask se hoti hai (neeche dekho),
  // isliye yahan rokne ki zarurat hi nahi.
  void _onStrokeExtended(ColoringStrokeExtended event, Emitter<MagicColoringStates> emit) {
    final active = state.activeStroke;
    if (active == null) return;
    emit(state.copyWith(activeStroke: active.copyWith(points: [...active.points, event.point])));
  }

 Future<void> _onStrokeEnded(ColoringStrokeEnded event, Emitter<MagicColoringStates> emit) async {
  final active = state.activeStroke;
  final regionData = state.regionData;
  if (active == null || regionData == null) {
    emit(state.copyWith(clearActiveStroke: true));
    return;
  }

  final ui.Image? clipMask = active.regionMask; // 👈 ab eraser ke liye bhi mask hai

  if (clipMask == null) {
    emit(state.copyWith(clearActiveStroke: true));
    return;
  }

  final baked = await _bakeStroke(
    base: state.bakedLayer,
    stroke: active,
    clipMask: clipMask,
    glitterTexture: state.glitterTexture,
    width: regionData.width,
    height: regionData.height,
  );

  final bool isBackgroundPaintStroke =
      active.regionId == kBackgroundRegionId && !active.isEraser;

  Map<int, PaletteColor>? updatedRegionColors;
  if (!active.isEraser &&
      active.regionId != kBackgroundRegionId &&
      active.regionId != -1) {
    updatedRegionColors = Map<int, PaletteColor>.of(state.regionColors)
      ..[active.regionId] = active.palette!;
  }

  emit(state.copyWith(
    bakedLayer: baked,
    clearActiveStroke: true,
    backgroundPalette: isBackgroundPaintStroke ? active.palette : state.backgroundPalette,
    regionColors: updatedRegionColors ?? state.regionColors,
  ));
}

  Future<ui.Image> _getOrBuildRegionMask(dynamic regionData, int regionId) async {
    ui.Image? cached = _regionMaskCache[regionId];
    if (cached != null) return cached;

    final maskBytes = ImageUtils.buildRegionMaskRgba(
      regionData.regionMap,
      regionData.width,
      regionData.height,
      regionId,
    );
    final img = await ImageUtils.decodeRgba(maskBytes, regionData.width, regionData.height);
    _regionMaskCache[regionId] = img;
    return img;
  }

  Future<ui.Image> _bakeStroke({
  required ui.Image? base,
  required BrushStrokeData stroke,
  required ui.Image? clipMask,
  required ui.Image? glitterTexture,
  required int width,
  required int height,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

  if (base != null) {
    canvas.drawImage(base, Offset.zero, Paint()..filterQuality = FilterQuality.none);
  }

  final clampedPoints = stroke.points.map((p) {
    return Offset(p.dx.clamp(0, width.toDouble()), p.dy.clamp(0, height.toDouble()));
  }).toList();

  final path = Path();
  if (clampedPoints.isNotEmpty) {
    path.moveTo(clampedPoints.first.dx, clampedPoints.first.dy);
    for (int i = 1; i < clampedPoints.length; i++) {
      path.lineTo(clampedPoints[i].dx, clampedPoints[i].dy);
    }
  }

  if (stroke.isEraser) {
    // 👇 masked-erase: eraser shape ek layer mein banao, domain-mask se clip
    // karo (dstIn), phir wahi clipped shape base image se dstOut blend se
    // hataao — is se erase sirf allowed domain ke andar hoga
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint()..blendMode = BlendMode.dstOut,
    );

    final eraseShapePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (clampedPoints.length == 1) {
      canvas.drawCircle(clampedPoints.first, stroke.strokeWidth / 2, Paint()..color = Colors.black);
    } else {
      canvas.drawPath(path, eraseShapePaint);
    }

    if (clipMask != null) {
      canvas.drawImage(
        clipMask,
        Offset.zero,
        Paint()
          ..blendMode = BlendMode.dstIn
          ..filterQuality = FilterQuality.none,
      );
    }

    canvas.restore();
  } else {
    canvas.saveLayer(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), Paint());

    final palette = stroke.palette!;
    final basePaint = Paint()
      ..color = palette.color
      ..blendMode = BlendMode.srcOver
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (clampedPoints.length == 1) {
      canvas.drawCircle(clampedPoints.first, stroke.strokeWidth / 2, Paint()..color = palette.color);
    } else {
      canvas.drawPath(path, basePaint);
    }

    if (palette.isGlitter && glitterTexture != null) {
      final shader = ui.ImageShader(glitterTexture, TileMode.repeated, TileMode.repeated, Matrix4.identity().storage);
      final glitterPaint = Paint()
        ..shader = shader
        ..blendMode = BlendMode.screen
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (clampedPoints.length == 1) {
        canvas.drawCircle(clampedPoints.first, stroke.strokeWidth / 2, Paint()..shader = shader..blendMode = BlendMode.screen);
      } else {
        canvas.drawPath(path, glitterPaint);
      }
    }

    if (clipMask != null) {
      canvas.drawImage(
        clipMask,
        Offset.zero,
        Paint()
          ..blendMode = BlendMode.dstIn
          ..filterQuality = FilterQuality.none,
      );
    }
    canvas.restore();
  }

  return recorder.endRecording().toImage(width, height);
}

  Future<void> _onBucketFillRequested(ColoringBucketFillRequested event, Emitter<MagicColoringStates> emit) async {
    final regionData = state.regionData;
    if (regionData == null) return;

    final rx = event.point.dx.round();
    final ry = event.point.dy.round();
    final regionId = regionData.regionAt(rx, ry);
    if (regionId == -1) return;

    if (regionId == kBackgroundRegionId) {
      await _fillWholeBackground(emit);
      return;
    }

    final regionMask = await _getOrBuildRegionMask(regionData, regionId);

    final baked = await _bakeBucketFill(
      base: state.bakedLayer,
      palette: state.selectedPalette,
      glitterTexture: state.glitterTexture,
      regionMask: regionMask,
      width: regionData.width,
      height: regionData.height,
    );

    final updatedColors = Map<int, PaletteColor>.of(state.regionColors)..[regionId] = state.selectedPalette;
    emit(state.copyWith(bakedLayer: baked, regionColors: updatedColors));
  }

  Future<void> _onBackgroundFillRequested(ColoringBackgroundFillRequested event, Emitter<MagicColoringStates> emit) async {
    await _fillWholeBackground(emit);
  }

  Future<void> _fillWholeBackground(Emitter<MagicColoringStates> emit) async {
    final regionData = state.regionData;
    final backgroundMask = state.backgroundMask;

    if (regionData == null || backgroundMask == null) return;

    final baked = await _bakeBucketFill(
      base: state.bakedLayer,
      palette: state.selectedPalette,
      glitterTexture: state.glitterTexture,
      regionMask: backgroundMask,
      width: regionData.width,
      height: regionData.height,
    );

    emit(
      state.copyWith(
        bakedLayer: baked,
        backgroundPalette: state.selectedPalette,
      ),
    );
  }

  Future<ui.Image> _bakeBucketFill({
    required ui.Image? base,
    required PaletteColor palette,
    required ui.Image? glitterTexture,
    required ui.Image regionMask,
    required int width,
    required int height,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    if (base != null) {
      canvas.drawImage(base, Offset.zero, Paint()..filterQuality = FilterQuality.none);
    }

    canvas.saveLayer(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), Paint());

    final fillRect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    canvas.drawRect(fillRect, Paint()..color = palette.color..blendMode = BlendMode.srcOver);

    if (palette.isGlitter && glitterTexture != null) {
      final shader = ui.ImageShader(glitterTexture, TileMode.repeated, TileMode.repeated, Matrix4.identity().storage);
      canvas.drawRect(fillRect, Paint()..shader = shader..blendMode = BlendMode.screen);
    }

    canvas.drawImage(
      regionMask,
      Offset.zero,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..filterQuality = FilterQuality.none,
    );
    canvas.restore();

    return recorder.endRecording().toImage(width, height);
  }

  void _onColoringCleared(ColoringCleared event, Emitter<MagicColoringStates> emit) {
    emit(state.copyWith(
      clearBakedLayer: true,
      regionColors: {},
      clearBackgroundPalette: true,
    ));
  }

  Future<void> _onSaveRequested(ColoringSaveRequested event, Emitter<MagicColoringStates> emit) async {
  final sketchId = state.currentSketchId;
  final baked = state.bakedLayer;
  if (sketchId == null || baked == null) return;

  emit(state.copyWith(canvasStatus: ColoringCanvasStatus.saving));

  try {
    // 1. bakedLayer ko PNG bytes mein encode karo (client-side, jaisa real apps karte hain)
    final pngBytes = await ImageUtils.encodePng(baked);

    // 2. upload karo — dummy abhi local hai, API aane pe yehi function real upload karega
    final imageUrl = await repository.uploadColoredImage(
      childId: state.childId,
      sketchId: sketchId,
      pngBytes: pngBytes,
    );

    // 3. progress save karo (URL + lightweight metadata)
    await repository.saveColoringProgress(
      childId: state.childId,
      sketchId: sketchId,
      coloredImageUrl: imageUrl,
      regionColors: state.regionColors,
      backgroundPalette: state.backgroundPalette,
    );

    emit(state.copyWith(canvasStatus: ColoringCanvasStatus.ready));

    developer.log('Coloring saved successfully for sketch: $sketchId', name: 'MagicColoring');
  } catch (e) {
    emit(state.copyWith(canvasStatus: ColoringCanvasStatus.error, canvasErrorMessage: e.toString()));
  }
}

  @override
  Future<void> close() {
    for (final img in _regionMaskCache.values) {
      img.dispose();
    }
    return super.close();
  }
}