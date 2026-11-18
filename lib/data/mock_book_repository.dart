import 'book.dart';
import 'book_repository.dart';
import 'mock_data.dart';
import 'result.dart';

// data/mock_book_repository.dart — память, с повадками сети
class MockBookRepository implements BookRepository {
  final List<Book> _books = List.of(MockData.books); // seed из L2
  int _nextId = 1000; // выше любого id из seed-а
  bool simulateError = false; // авария: включена → любой вызов проваливается

  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<Book>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.of(_books)); // копия — внутренность не отдаётся из рук
  }

  @override
  Future<Result<Book>> fetchById(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _books.indexWhere((b) => b.id == id);
    if (index == -1) return const Err('Книга не найдена');
    return Ok(_books[index]);
  }

  @override
  Future<Result<Book>> create(Book book) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final created = book.copyWith(id: (_nextId++).toString());
    _books.add(created);
    return Ok(created);
  }

  @override
  Future<Result<Book>> update(Book book) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index == -1) return const Err('Книга не найдена');
    _books[index] = book;
    return Ok(book);
  }

  @override
  Future<Result<void>> delete(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _books.indexWhere((b) => b.id == id);
    if (index == -1) return const Err('Книга не найдена');
    _books.removeAt(index);
    return const Ok(null);
  }
}
