import 'dart:convert';
import 'dart:typed_data';

import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/dummy/dummy_my_drawings.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/dummy/dummy_sketch_categories.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/dummy/dummy_sketches.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/my_drawing_entry_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_category_model.dart';
import '../dummy/dummy_child_data.dart';
import '../dummy/dummy_books_data.dart';
import '../dummy/dummy_progress_data.dart';
import '../models/book_model.dart';
import '../models/sketch_template_model.dart';
import '../models/child_sketch_progress_model.dart';
import '../config/coloring_capability_config.dart';

abstract class MagicColoringRepository {
  // ── Session / onboarding ──
  Future<bool> hasSeenOnboarding(String childId);
  Future<void> markOnboardingSeen(String childId);
  Future<AgeGroup> getAgeGroup(String childId);

  // ── Catalog ──
  Future<List<BookModel>> getBooks();
  Future<List<SketchTemplateModel>> getSketches(String bookId);
  Future<List<SketchCategoryModel>> getSketchCategories(String bookId);

  // ── Progress ──
  Future<List<ChildSketchProgressModel>> getProgress(String childId);
  Future<ChildSketchProgressModel> saveProgress({
    required String childId,
    required String sketchId,
    required String coloredImageUrl,
    required Map<int, PaletteColor> regionColors,
  });

  Future<String> uploadColoredImage({
    required String childId,
    required String sketchId,
    required Uint8List pngBytes,
  });

  Future<void> saveColoringProgress({
    required String childId,
    required String sketchId,
    required String coloredImageUrl,
    required Map<int, PaletteColor> regionColors,
    required PaletteColor? backgroundPalette,
  });

  Future<ColoringProgressResult?> loadColoringProgress({
    required String childId,
    required String sketchId,
  });

  Future<List<MyDrawingEntryModel>> getMyDrawings(String childId);
  Future<void> deleteMyDrawing(String drawingId);
}

// ═══════════════════════════════════════════════
// Dummy implementation — abhi testing ke liye
// ═══════════════════════════════════════════════
class DummyMagicColoringRepository implements MagicColoringRepository {
  static String _onboardingKey(String childId) =>
      'magic_coloring_onboarding_seen_$childId';

  @override
  Future<bool> hasSeenOnboarding(String childId) async {
    return StorageService.getBool(_onboardingKey(childId));
  }

  @override
  Future<void> markOnboardingSeen(String childId) async {
    await StorageService.setBool(_onboardingKey(childId), true);
  }

  @override
  Future<AgeGroup> getAgeGroup(String childId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyChildData.ageGroup;
  }

  @override
  Future<List<BookModel>> getBooks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyBooksData.all;
  }

  @override
  Future<List<SketchTemplateModel>> getSketches(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummySketchesData.forBook(bookId);
  }

  @override
  Future<List<SketchCategoryModel>> getSketchCategories(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (bookId == 'book_sketches') {
      return DummySketchCategoriesData.forSketchesBook;
    }
    return [];
  }

  @override
  Future<List<ChildSketchProgressModel>> getProgress(String childId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyProgressData.all;
  }

  @override
  Future<ChildSketchProgressModel> saveProgress({
    required String childId,
    required String sketchId,
    required String coloredImageUrl,
    required Map<int, PaletteColor> regionColors,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final progress = ChildSketchProgressModel(
      childId: childId,
      sketchTemplateId: sketchId,
      coloredImageUrl: coloredImageUrl,
      regionColors: regionColors,
      isCompleted: true,
      rewardClaimed: false,
      updatedAt: DateTime.now(),
    );
    DummyProgressData.upsert(
      progress,
    ); // in-memory update, taake list refresh pe dikhe
    return progress;
  }

  static String _progressKey(String childId, String sketchId) =>
      'coloring_progress_${childId}_$sketchId';

  @override
  Future<String> uploadColoredImage({
    required String childId,
    required String sketchId,
    required Uint8List pngBytes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final base64Data = base64Encode(pngBytes);
    return 'local://$base64Data';
  }

  @override
  Future<void> saveColoringProgress({
    required String childId,
    required String sketchId,
    required String coloredImageUrl,
    required Map<int, PaletteColor> regionColors,
    required PaletteColor? backgroundPalette,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final payload = {
      'coloredImageUrl': coloredImageUrl,
      'regionColors': regionColors.map(
        (id, palette) => MapEntry(id.toString(), palette.toJson()),
      ),
      'backgroundPalette': backgroundPalette?.toJson(),
    };

    await StorageService.setString(
      _progressKey(childId, sketchId),
      jsonEncode(payload),
    );
  }

  @override
  Future<ColoringProgressResult?> loadColoringProgress({
    required String childId,
    required String sketchId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final raw = StorageService.getString(_progressKey(childId, sketchId));
    if (raw == null) return null;

    final Map<String, dynamic> decoded = jsonDecode(raw);
    final Map<String, dynamic> rawColors =
        (decoded['regionColors'] as Map? ?? {}).cast<String, dynamic>();

    return ColoringProgressResult(
      coloredImageUrl: decoded['coloredImageUrl'] as String,
      regionColors: rawColors.map(
        (id, paletteJson) => MapEntry(
          int.parse(id),
          PaletteColor.fromJson((paletteJson as Map).cast<String, dynamic>()),
        ),
      ),
      backgroundPalette: decoded['backgroundPalette'] != null
          ? PaletteColor.fromJson(
              (decoded['backgroundPalette'] as Map).cast<String, dynamic>(),
            )
          : null,
    );
  }

  @override
  Future<List<MyDrawingEntryModel>> getMyDrawings(String childId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyMyDrawingsData.all;
  }

  @override
  Future<void> deleteMyDrawing(String drawingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    DummyMyDrawingsData.remove(drawingId);
  }
}

class ColoringProgressResult {
  final String coloredImageUrl;
  final Map<int, PaletteColor> regionColors;
  final PaletteColor? backgroundPalette;

  const ColoringProgressResult({
    required this.coloredImageUrl,
    required this.regionColors,
    this.backgroundPalette,
  });
}
