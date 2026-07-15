import '../models/my_drawing_entry_model.dart';

class DummyMyDrawingsData {
  static List<MyDrawingEntryModel> all = [
    MyDrawingEntryModel(
      id: 'drawing_001',
      childId: 'dummy_child',
      sourceSketchId: 'sketch_castle_01',
      coloredImageUrl: 'assets/png/castle_sketch_1.png',
      regionColors: const {},
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static void remove(String id) {
    all.removeWhere((d) => d.id == id);
  }
}