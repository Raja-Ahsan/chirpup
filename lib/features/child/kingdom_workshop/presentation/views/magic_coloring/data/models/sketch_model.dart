class SketchItem {
  final String imagePath;
  final bool isLocked;
  final int? lockNumber;

  const SketchItem({
    required this.imagePath,
    this.isLocked = false,
    this.lockNumber,
  });
}