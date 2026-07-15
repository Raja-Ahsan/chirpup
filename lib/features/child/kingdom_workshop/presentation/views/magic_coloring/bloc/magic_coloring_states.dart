import 'dart:ui' as ui;
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/config/coloring_capability_config.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/my_drawing_entry_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_category_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_template_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/region_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ColoringCanvasStatus { initial, processingRegions, ready, saving, error }

class BrushStrokeData {
  final List<Offset> points;
  final PaletteColor? palette;
  final double strokeWidth;
  final bool isEraser;
  final int regionId;
  final ui.Image? regionMask;

  const BrushStrokeData({
    required this.points,
    required this.palette,
    required this.strokeWidth,
    required this.isEraser,
    required this.regionId,
    this.regionMask,
  });

  BrushStrokeData copyWith({List<Offset>? points}) => BrushStrokeData(
        points: points ?? this.points,
        palette: palette,
        strokeWidth: strokeWidth,
        isEraser: isEraser,
        regionId: regionId,
        regionMask: regionMask,
      );
}

class MagicColoringStates extends Equatable {
  final bool isLoading;
  final String childId;
  final String characterId;
  final bool hasSeenOnboarding;
  final AgeGroup ageGroup;
  final String? errorMessage;
  final bool isSketchesLoading;
  final List<SketchCategoryModel> sketchCategories;
  final List<SketchTemplateModel> sketches;
  final String? selectedCategoryId;
  final bool isMyDrawingsLoading;
  final List<MyDrawingEntryModel> myDrawings;

  // ── Coloring canvas state ──
  final ColoringCanvasStatus canvasStatus;
  final ColoringToolMode selectedTool;
  final PaletteColor selectedPalette;
  final double brushSize;
  final String? currentSketchId;
  final RegionData? regionData;
  final ui.Image? sketchImage;
  final ui.Image? fillableMask;
  final ui.Image? glitterTexture;
  final Map<int, PaletteColor> regionColors;
  final ui.Image? bakedLayer;
  final BrushStrokeData? activeStroke;
  final String? canvasErrorMessage;
  final bool isColorPickerActive;
  final ui.Image? backgroundMask;
  final PaletteColor? backgroundPalette;

  const MagicColoringStates({
    this.isLoading = true,
    this.childId = '',
    this.characterId = '',
    this.hasSeenOnboarding = false,
    this.ageGroup = AgeGroup.age5to6,
    this.errorMessage,
    this.isSketchesLoading = false,
    this.sketchCategories = const [],
    this.sketches = const [],
    this.selectedCategoryId,
    this.canvasStatus = ColoringCanvasStatus.initial,
    this.selectedTool = ColoringToolMode.brush,
    this.selectedPalette = const PaletteColor(id: 'blue', color: Color(0xff4A90D9)),
    this.brushSize = 22,
    this.currentSketchId,
    this.regionData,
    this.sketchImage,
    this.fillableMask,
    this.glitterTexture,
    this.regionColors = const {},
    this.bakedLayer,
    this.activeStroke,
    this.canvasErrorMessage,
    this.isColorPickerActive = false,
    this.backgroundMask,
    this.backgroundPalette,
    this.isMyDrawingsLoading = false,
    this.myDrawings = const [],
  });

  List<SketchTemplateModel> get sketchesForSelectedCategory {
    if (selectedCategoryId == null) return sketches;
    return sketches.where((s) => s.categoryId == selectedCategoryId).toList();
  }

  MagicColoringStates copyWith({
    bool? isLoading,
    String? childId,
    String? characterId,
    bool? hasSeenOnboarding,
    AgeGroup? ageGroup,
    String? errorMessage,
    bool? isSketchesLoading,
    List<SketchCategoryModel>? sketchCategories,
    List<SketchTemplateModel>? sketches,
    String? selectedCategoryId,
    ColoringCanvasStatus? canvasStatus,
    ColoringToolMode? selectedTool,
    PaletteColor? selectedPalette,
    double? brushSize,
    String? currentSketchId,
    RegionData? regionData,
    ui.Image? sketchImage,
    ui.Image? fillableMask,
    ui.Image? glitterTexture,
    Map<int, PaletteColor>? regionColors,
    ui.Image? bakedLayer,
    bool clearBakedLayer = false,
    BrushStrokeData? activeStroke,
    bool clearActiveStroke = false,
    String? canvasErrorMessage,
    bool? isColorPickerActive,
    ui.Image? backgroundMask,
    PaletteColor? backgroundPalette,
    bool clearBackgroundPalette = false,
    bool? isMyDrawingsLoading,
    List<MyDrawingEntryModel>? myDrawings,
  }) {
    return MagicColoringStates(
      isLoading: isLoading ?? this.isLoading,
      childId: childId ?? this.childId,
      characterId: characterId ?? this.characterId,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      ageGroup: ageGroup ?? this.ageGroup,
      errorMessage: errorMessage,
      isSketchesLoading: isSketchesLoading ?? this.isSketchesLoading,
      sketchCategories: sketchCategories ?? this.sketchCategories,
      sketches: sketches ?? this.sketches,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      canvasStatus: canvasStatus ?? this.canvasStatus,
      selectedTool: selectedTool ?? this.selectedTool,
      selectedPalette: selectedPalette ?? this.selectedPalette,
      brushSize: brushSize ?? this.brushSize,
      currentSketchId: currentSketchId ?? this.currentSketchId,
      regionData: regionData ?? this.regionData,
      sketchImage: sketchImage ?? this.sketchImage,
      fillableMask: fillableMask ?? this.fillableMask,
      glitterTexture: glitterTexture ?? this.glitterTexture,
      regionColors: regionColors ?? this.regionColors,
      bakedLayer: clearBakedLayer ? null : (bakedLayer ?? this.bakedLayer),
      activeStroke: clearActiveStroke ? null : (activeStroke ?? this.activeStroke),
      canvasErrorMessage: canvasErrorMessage,
      isColorPickerActive: isColorPickerActive ?? this.isColorPickerActive,
      backgroundMask: backgroundMask ?? this.backgroundMask,
      backgroundPalette: clearBackgroundPalette ? null : (backgroundPalette ?? this.backgroundPalette),
      isMyDrawingsLoading: isMyDrawingsLoading ?? this.isMyDrawingsLoading,
      myDrawings: myDrawings ?? this.myDrawings,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        childId,
        characterId,
        hasSeenOnboarding,
        ageGroup,
        errorMessage,
        isSketchesLoading,
        sketchCategories,
        sketches,
        selectedCategoryId,
        canvasStatus,
        selectedTool,
        selectedPalette,
        brushSize,
        currentSketchId,
        regionData,
        sketchImage,
        fillableMask,
        glitterTexture,
        regionColors,
        bakedLayer,
        activeStroke,
        canvasErrorMessage,
        isColorPickerActive,
        backgroundMask,
        backgroundPalette,
        isMyDrawingsLoading,
        myDrawings,
      ];
}