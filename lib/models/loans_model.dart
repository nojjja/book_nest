import 'package:flutter/foundation.dart';
import '../data/loan.dart';

// models/loans_model.dart — разделяемое состояние: чистый Dart, без widget-ов
class LoansModel extends ChangeNotifier {
  final List<Loan> _items = [];

  List<Loan> get items => List.unmodifiable(_items);
  int get count => _items.length;

  void add(Loan loan) {
    _items.add(loan);
    notifyListeners(); // весть уходит ко ВСЕМ подписчикам
  }

  void remove(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners(); // весть уходит ко ВСЕМ подписчикам
  }
}
