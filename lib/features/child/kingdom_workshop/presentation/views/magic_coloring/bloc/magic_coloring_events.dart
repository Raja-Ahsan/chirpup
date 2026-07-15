import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MagicColoringEvent extends Equatable {
  const MagicColoringEvent();
  @override
  List<Object?> get props => [];
}

class MagicColoringStarted extends MagicColoringEvent {
  final String childId;
  final String characterId;
  const MagicColoringStarted(this.childId, this.characterId);
  @override
  List<Object?> get props => [childId, characterId];
}

class OnboardingCompleted extends MagicColoringEvent {
  const OnboardingCompleted();
}

class SketchesForBookRequested extends MagicColoringEvent {
  final String bookId;
  const SketchesForBookRequested(this.bookId);
  @override
  List<Object?> get props => [bookId];
}

class SketchCategorySelected extends MagicColoringEvent {
  final String categoryId;
  const SketchCategorySelected(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class MyDrawingsRequested extends MagicColoringEvent {
  final String childId;
  const MyDrawingsRequested(this.childId);
  @override
  List<Object?> get props => [childId];
}

class MyDrawingDeleteRequested extends MagicColoringEvent {
  final String drawingId;
  const MyDrawingDeleteRequested(this.drawingId);
  @override
  List<Object?> get props => [drawingId];
}

// ═══════════════════════════════════════════════
// ── Coloring canvas events ──
// ═══════════════════════════════════════════════

enum ColoringToolMode { brush, bucket, glitterPen, eraser }

class ColoringImageLoaded extends MagicColoringEvent {
  final String sketchId;
  final String assetPath;
  const ColoringImageLoaded({required this.sketchId, required this.assetPath});
  @override
  List<Object?> get props => [sketchId, assetPath];
}

class ColoringToolChanged extends MagicColoringEvent {
  final ColoringToolMode tool;
  const ColoringToolChanged(this.tool);
  @override
  List<Object?> get props => [tool];
}

class ColoringColorSelected extends MagicColoringEvent {
  final PaletteColor palette;
  const ColoringColorSelected(this.palette);
  @override
  List<Object?> get props => [palette];
}

class ColoringBrushSizeChanged extends MagicColoringEvent {
  final double size;
  const ColoringBrushSizeChanged(this.size);
  @override
  List<Object?> get props => [size];
}

class ColoringStrokeStarted extends MagicColoringEvent {
  final Offset point;
  const ColoringStrokeStarted(this.point);
  @override
  List<Object?> get props => [point];
}

class ColoringStrokeExtended extends MagicColoringEvent {
  final Offset point;
  const ColoringStrokeExtended(this.point);
  @override
  List<Object?> get props => [point];
}

class ColoringStrokeEnded extends MagicColoringEvent {
  const ColoringStrokeEnded();
}

class ColoringBucketFillRequested extends MagicColoringEvent {
  final Offset point;
  const ColoringBucketFillRequested(this.point);
  @override
  List<Object?> get props => [point];
}

class ColoringCleared extends MagicColoringEvent {
  const ColoringCleared();
}

class ColoringSaveRequested extends MagicColoringEvent {
  const ColoringSaveRequested();
}

class ColoringColorPickerToggled extends MagicColoringEvent {
  const ColoringColorPickerToggled();
}

class ColoringColorPickedFromCanvas extends MagicColoringEvent {
  final Offset point;
  const ColoringColorPickedFromCanvas(this.point);
  @override
  List<Object?> get props => [point];
}

class ColoringBackgroundFillRequested extends MagicColoringEvent {
  const ColoringBackgroundFillRequested();
}