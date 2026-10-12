class InstrumentPlacement {
  final String id;
  final String assetPath;
  final double? left; 
  final double? right;
  final double top;
  final double widthFactor;
  final bool playable;

  const InstrumentPlacement({
    required this.id,
    required this.assetPath,
    this.left,
    this.right,
    required this.top,
    required this.widthFactor,
    this.playable = true,
  });
}