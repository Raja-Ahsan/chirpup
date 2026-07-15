import '../models/book_model.dart';

class DummyBooksData {
  static const List<BookModel> all = [
    BookModel(id: 'book_sketches', type: 'sketchesBook', title: 'Sketches Book'),
    BookModel(id: 'book_my_drawing', type: 'myDrawingBook', title: 'My Drawing Book'),
    BookModel(id: 'book_character_studio', type: 'characterStudioBook', title: 'Character Studio'),
  ];
}