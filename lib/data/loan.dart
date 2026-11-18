class Loan {
  final String id;
  final String bookTitle;
  final String borrowerName;
  final String dueDate;
  final String status; // "Выдана" или "Взята"

  const Loan({
    required this.id,
    required this.bookTitle,
    required this.borrowerName,
    required this.dueDate,
    required this.status,
  });

  Loan copyWith({
    String? id,
    String? bookTitle,
    String? borrowerName,
    String? dueDate,
    String? status,
  }) {
    return Loan(
      id: id ?? this.id,
      bookTitle: bookTitle ?? this.bookTitle,
      borrowerName: borrowerName ?? this.borrowerName,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}
