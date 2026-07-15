enum AgeGroup { age1to2, age3to4, age5to6, age7to8, age9plus }

enum ColoringToolType { bucket, brush, glitterPen, eraser, colorPicker }

enum BookType { sketchesBook, myDrawingBook, characterStudioBook }

class ColoringCapabilities {
  final Set<ColoringToolType> allowedTools;
  final bool rewardEnabled;
  final bool showCompletedGalleryScreen;
  final Set<BookType> visibleBooks;
  final bool bookmarkEnabled;

  const ColoringCapabilities({
    required this.allowedTools,
    required this.rewardEnabled,
    required this.showCompletedGalleryScreen,
    required this.visibleBooks,
    required this.bookmarkEnabled,
  });
}

class ColoringCapabilityConfig {
  static const Map<AgeGroup, ColoringCapabilities> byAgeGroup = {
    AgeGroup.age1to2: ColoringCapabilities(
      allowedTools: {ColoringToolType.bucket},
      rewardEnabled: false,
      showCompletedGalleryScreen: false,
      visibleBooks: {BookType.sketchesBook},
      bookmarkEnabled: false,
    ),
    AgeGroup.age3to4: ColoringCapabilities(
      allowedTools: {ColoringToolType.bucket, ColoringToolType.brush},
      rewardEnabled: true,
      showCompletedGalleryScreen: true,
      visibleBooks: {BookType.sketchesBook},
      bookmarkEnabled: false,
    ),
    AgeGroup.age5to6: ColoringCapabilities(
      allowedTools: {
        ColoringToolType.bucket,
        ColoringToolType.brush,
        ColoringToolType.glitterPen,
        ColoringToolType.eraser,
      },
      rewardEnabled: true,
      showCompletedGalleryScreen: true,
      visibleBooks: {BookType.sketchesBook, BookType.myDrawingBook},
      bookmarkEnabled: true,
    ),
    AgeGroup.age7to8: ColoringCapabilities(
      allowedTools: {
        ColoringToolType.bucket,
        ColoringToolType.brush,
        ColoringToolType.glitterPen,
        ColoringToolType.eraser,
        ColoringToolType.colorPicker,
      },
      rewardEnabled: true,
      showCompletedGalleryScreen: true,
      visibleBooks: {BookType.sketchesBook, BookType.myDrawingBook},
      bookmarkEnabled: true,
    ),
    AgeGroup.age9plus: ColoringCapabilities(
      allowedTools: {
        ColoringToolType.bucket,
        ColoringToolType.brush,
        ColoringToolType.glitterPen,
        ColoringToolType.eraser,
        ColoringToolType.colorPicker,
      },
      rewardEnabled: true,
      showCompletedGalleryScreen: true,
      visibleBooks: {
        BookType.sketchesBook,
        BookType.myDrawingBook,
        BookType.characterStudioBook,
      },
      bookmarkEnabled: true,
    ),
  };
}