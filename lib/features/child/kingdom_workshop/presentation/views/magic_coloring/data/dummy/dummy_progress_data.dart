import '../models/child_sketch_progress_model.dart';

class DummyProgressData {
  static final List<ChildSketchProgressModel> all = [
    // shuru mein khaali ya kuch pre-filled test entries daal sakte ho
  ];

  static void upsert(ChildSketchProgressModel progress) {
    all.removeWhere((p) => p.sketchTemplateId == progress.sketchTemplateId);
    all.add(progress);
  }
}