import '../models/sketch_template_model.dart';

class DummySketchesData {
  static const List<SketchTemplateModel> _sketchesBook = [
    SketchTemplateModel(
      id: 'sketch_castle_01',
      bookId: 'book_sketches',
      categoryId: 'cat_castle',
      name: 'Sand Castle',
      assetUrl: 'assets/png/castle_sketch_1.png',
      thumbnailUrl: 'assets/png/castle_sketch_1.png',
    ),
    SketchTemplateModel(
      id: 'sketch_castle_02',
      bookId: 'book_sketches',
      categoryId: 'cat_castle',
      name: 'Castle',
      assetUrl: 'assets/png/castle_sketch_2.png',
      thumbnailUrl: 'assets/png/castle_sketch_2.png',
    ),
    SketchTemplateModel(
      id: 'sketch_castle_03',
      bookId: 'book_sketches',
      categoryId: 'cat_castle',
      name: 'Castle Flags',
      assetUrl: 'assets/png/castle_sketch_3.png',
      thumbnailUrl: 'assets/png/castle_sketch_3.png',
    ),
    SketchTemplateModel(
      id: 'sketch_horse_01',
      bookId: 'book_sketches',
      categoryId: 'cat_horse',
      name: 'Unicorn',
      assetUrl: 'assets/png/castle_sketch_3.png',
      thumbnailUrl: 'assets/png/castle_sketch_3.png',
    ),
    SketchTemplateModel(
      id: 'sketch_horse_02',
      bookId: 'book_sketches',
      categoryId: 'cat_horse',
      name: 'Horse',
      assetUrl: 'assets/png/castle_sketch_3.png',
      thumbnailUrl: 'assets/png/castle_sketch_3.png',
    ),
  ];

  static const List<SketchTemplateModel> _characterStudio = [
    SketchTemplateModel(
      id: 'sketch_prince',
      bookId: 'book_character_studio',
      categoryId: 'cat_characters',
      name: 'Prince',
      assetUrl: 'assets/png/prince_sketch.png',
      thumbnailUrl: 'assets/png/prince_sketch.png',
    ),
     SketchTemplateModel(
      id: 'sketch_princess',
      bookId: 'book_character_studio',
      categoryId: 'cat_characters',
      name: 'Princess',
      assetUrl: 'assets/png/princess_sketch.png',
      thumbnailUrl: 'assets/png/princess_sketch.png',
    ),
    // knight, dragon isi tarah

  ];

  static List<SketchTemplateModel> forBook(String bookId) {
    switch (bookId) {
      case 'book_sketches':
        return _sketchesBook;
      case 'book_character_studio':
        return _characterStudio;
      default:
        return [];
    }
  }
}
