import 'loan.dart';
import 'loan_repository.dart';
import 'mock_data.dart';
import 'result.dart';

// data/mock_loan_repository.dart — mock-хранилище выдач с задержкой и аварией
class MockLoanRepository implements LoanRepository {
  final List<Loan> _loans = List.of(MockData.loans); // seed из L2
  int _nextId = 1000;
  bool simulateError = false;

  static const _latency = Duration(milliseconds: 800);
  static const _errNetwork = 'Сервер не отвечает — повторите попытку';

  @override
  Future<Result<List<Loan>>> fetchAll() async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    return Ok(List.of(_loans));
  }

  @override
  Future<Result<Loan>> fetchById(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _loans.indexWhere((l) => l.id == id);
    if (index == -1) return const Err('Запись обмена не найдена');
    return Ok(_loans[index]);
  }

  @override
  Future<Result<Loan>> create(Loan loan) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final created = loan.copyWith(id: 'l${_nextId++}');
    _loans.add(created);
    return Ok(created);
  }

  @override
  Future<Result<Loan>> update(Loan loan) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _loans.indexWhere((l) => l.id == loan.id);
    if (index == -1) return const Err('Запись обмена не найдена');
    _loans[index] = loan;
    return Ok(loan);
  }

  @override
  Future<Result<void>> delete(String id) async {
    await Future.delayed(_latency);
    if (simulateError) return const Err(_errNetwork);
    final index = _loans.indexWhere((l) => l.id == id);
    if (index == -1) return const Err('Запись обмена не найдена');
    _loans.removeAt(index);
    return const Ok(null);
  }
}
