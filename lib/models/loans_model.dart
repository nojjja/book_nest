import 'package:flutter/foundation.dart';

import '../data/loan.dart';
import '../data/loan_repository.dart';
import '../data/result.dart';

// models/loans_model.dart — разделяемое состояние выдач/обменов с репозиторием
class LoansModel extends ChangeNotifier {
  LoansModel(this._repository); // DI через конструктор (интерфейс)

  final LoanRepository _repository;

  bool _loading = false;
  String? _error;
  List<Loan> _loans = const [];

  bool get isLoading => _loading;
  String? get error => _error;
  List<Loan> get items => List.unmodifiable(_loans);
  int get count => _loans.length;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    switch (await _repository.fetchAll()) {
      case Ok(:final value):
        _loans = value;
      case Err(:final msg):
        _error = msg;
    }
    _loading = false;
    notifyListeners();
  }

  Future<String?> add(Loan loan) async {
    switch (await _repository.create(loan)) {
      case Ok(:final value):
        _loans = [..._loans, value];
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }

  Future<String?> update(Loan loan) async {
    switch (await _repository.update(loan)) {
      case Ok(:final value):
        _loans = [
          for (final item in _loans)
            if (item.id == value.id) value else item,
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
        _loans = _loans.where((item) => item.id != id).toList();
        notifyListeners();
        return null;
      case Err(:final msg):
        return msg;
    }
  }
}
