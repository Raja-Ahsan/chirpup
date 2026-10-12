class QuestInstrument {
  final String id;
  final String trayAsset;       // sheet mein dikhne wala
  final String roomAsset;       // room mein drop ke baad (aksar same)
  final bool isMain;            // full energy dene wala
  // room mein fix position:
  final double? left;
  final double? right;
  final double top;
  final double widthFactor;

  const QuestInstrument({
    required this.id,
    required this.trayAsset,
    required this.roomAsset,
    this.isMain = false,
    this.left,
    this.right,
    required this.top,
    required this.widthFactor,
  });
}