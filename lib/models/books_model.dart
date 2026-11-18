import 'package:flutter/foundation.dart';
import '../data/book.dart';
import '../data/book_repository.dart';
import '../data/result.dart';

// models/books_model.dart — состояние списка книг + триада с C8
class BooksModel extends ChangeNotifier {
  BooksModel(this._repository); // простой DI: хранилище — в конструктор

  final BookRepository _repository; // тип — ИНТЕРФЕЙС, а не mock!

  bool _loading = false;
  String? _error;
  List<Book> _records = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Book> get books => List.unmodifiable(_records);
  List<Book> get myBooks => List.unmodifiable(
        _records.where((b) => b.ownerId == 'user1'),
      );

  Book? byId(String id) {
    try {
      return _records.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners(); // подписанные экраны входят в состояние «грузится»

    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _records = value;
      case Err(:final msg):
        _error = msg;
    }
    _loading = false;
    notifyListeners(); // …и выходят: с товаром или с ошибкой — никогда молча
  }

  Future<String?> add(Book draft) async {
    switch (await _repository.create(draft)) {
      case Ok(:final value):
        _records = [..._records, value]; // с id-ом, полученным от хранилища
        notifyListeners(); // список, статистика — узнают все
        return null;
      case Err(:final msg):
        return msg; // состояние нетронуто — экран решает, что показать
    }
  }

  Future<String?> update(Book record) async {
    switch (await _repository.update(record)) {
      case Ok(:final value):
        _records = [
          for (final b in _records)
            if (b.id == value.id) value else b
        ];
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }

  Future<String?> remove(String id) async {
    switch (await _repository.delete(id)) {
      case Ok():
        _records = _records.where((b) => b.id != id).toList();
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
