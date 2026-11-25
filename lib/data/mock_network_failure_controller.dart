import 'mock_book_repository.dart';
import 'mock_loan_repository.dart';
import 'network_failure_controller.dart';

/// Coordinates the mock failure switch for all repositories in the app.
class MockNetworkFailureController implements NetworkFailureController {
  MockNetworkFailureController({required this._books, required this._loans});

  final MockBookRepository _books;
  final MockLoanRepository _loans;

  @override
  bool get enabled => _books.simulateError && _loans.simulateError;

  @override
  void setEnabled(bool value) {
    _books.simulateError = value;
    _loans.simulateError = value;
  }
}
