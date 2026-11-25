enum LoanStatus { active, completed }

class Loan {
  final String id;
  final String bookId;
  final String borrowerId;
  final String startDate;
  final String dueDate;
  final LoanStatus status;
  final String borrowerName;

  const Loan({
    required this.id,
    required this.bookId,
    required this.borrowerId,
    required this.startDate,
    required this.dueDate,
    required this.status,
    this.borrowerName = '',
  });

  Loan copyWith({
    String? id,
    String? bookId,
    String? borrowerId,
    String? startDate,
    String? dueDate,
    LoanStatus? status,
    String? borrowerName,
  }) {
    return Loan(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      borrowerId: borrowerId ?? this.borrowerId,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      borrowerName: borrowerName ?? this.borrowerName,
    );
  }
}
