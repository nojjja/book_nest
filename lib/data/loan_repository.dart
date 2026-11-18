import 'loan.dart';
import 'result.dart';

// data/loan_repository.dart — контракт для выдач/обменов книг
abstract class LoanRepository {
  Future<Result<List<Loan>>> fetchAll();
  Future<Result<Loan>> fetchById(String id);
  Future<Result<Loan>> create(Loan loan);
  Future<Result<Loan>> update(Loan loan);
  Future<Result<void>> delete(String id);
}
