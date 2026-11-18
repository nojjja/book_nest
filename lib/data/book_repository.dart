import 'book.dart';
import 'result.dart';

// data/book_repository.dart — контракт: ЧТО можно просить, а не КАК
abstract class BookRepository {
  Future<Result<List<Book>>> fetchAll();
  Future<Result<Book>> fetchById(String id);
  Future<Result<Book>> create(Book book);
  Future<Result<Book>> update(Book book);
  Future<Result<void>> delete(String id);
}
