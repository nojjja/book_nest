class Book {
  final String id;
  final String ownerId;
  final String title;
  final String author;
  final String genre;
  final String coverUrl;
  final String status; // "Доступна" или "Выдана"

  const Book({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    required this.genre,
    required this.coverUrl,
    required this.status,
  });

  Book copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? author,
    String? genre,
    String? coverUrl,
    String? status,
  }) {
    return Book(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      coverUrl: coverUrl ?? this.coverUrl,
      status: status ?? this.status,
    );
  }
}
