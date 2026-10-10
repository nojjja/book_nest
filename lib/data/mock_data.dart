
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
}

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
}

class MockData {
  // Не менее 8 книг для проверки верстки (длинные названия, разные авторы)
  static const List<Book> books = [
    Book(
      id: '1',
      ownerId: 'user1',
      title: 'Чистый код: создание, анализ и рефакторинг',
      author: 'Роберт Мартин',
      genre: 'Программирование',
      coverUrl: '',
      status: 'Доступна',
    ),
    Book(
      id: '2',
      ownerId: 'user1',
      title: '1984 (Специальное издание)',
      author: 'Джордж Оруэлл',
      genre: 'Антиутопия',
      coverUrl: '',
      status: 'Выдана',
    ),
    Book(
      id: '3',
      ownerId: 'user1',
      title: 'Алгоритмы: построение и анализ (3-е издание)',
      author: 'Томас Кормен, Чарльз Лейзерсон',
      genre: 'Образование',
      coverUrl: '',
      status: 'Доступна',
    ),
    Book(
      id: '4',
      ownerId: 'user2',
      title: 'Совершенный код',
      author: 'Стив Макконнелл',
      genre: 'Программирование',
      coverUrl: '',
      status: 'Доступна',
    ),
    Book(
      id: '5',
      ownerId: 'user2',
      title: 'Дюна',
      author: 'Фрэнк Герберт',
      genre: 'Фантастика',
      coverUrl: '',
      status: 'Выдана',
    ),
    Book(
      id: '6',
      ownerId: 'user3',
      title: 'Мартин Иден',
      author: 'Джек Лондон',
      genre: 'Классика',
      coverUrl: '',
      status: 'Доступна',
    ),
    Book(
      id: '7',
      ownerId: 'user3',
      title: 'Архитектура компьютеров',
      author: 'Эндрю Таненбаум',
      genre: 'Образование',
      coverUrl: '',
      status: 'Доступна',
    ),
    Book(
      id: '8',
      ownerId: 'user1',
      title: 'Искусство программирования',
      author: 'Дональд Кнут',
      genre: 'Образование',
      coverUrl: '',
      status: 'Выдана',
    ),
  ];

  static const List<Loan> loans = [
    Loan(id: 'l1', bookTitle: '1984 (Специальное издание)', borrowerName: 'Екатерина Трач', dueDate: '15.10.2026', status: 'Выдана'),
    Loan(id: 'l2', bookTitle: 'Дюна', borrowerName: 'Александр Сырбу', dueDate: '20.10.2026', status: 'Взята'),
    Loan(id: 'l3', bookTitle: 'Совершенный код', borrowerName: 'Иван Морарь', dueDate: '01.11.2026', status: 'Взята'),
    Loan(id: 'l4', bookTitle: 'Искусство программирования', borrowerName: 'Анна Киртока', dueDate: '05.11.2026', status: 'Выдана'),
    Loan(id: 'l5', bookTitle: 'Чистый код: создание, анализ и рефакторинг', borrowerName: 'Дмитрий Чебан', dueDate: '12.11.2026', status: 'Выдана'),
    Loan(id: 'l6', bookTitle: 'Мартин Иден', borrowerName: 'Елена Русу', dueDate: '18.11.2026', status: 'Взята'),
    Loan(id: 'l7', bookTitle: 'Алгоритмы: построение и анализ', borrowerName: 'Мария Ботнарь', dueDate: '22.11.2026', status: 'Выдана'),
    Loan(id: 'l8', bookTitle: 'Цветы для Элджернона', borrowerName: 'Виктор Лупу', dueDate: '25.11.2026', status: 'Взята'),
    Loan(id: 'l9', bookTitle: 'Мастер и Маргарита', borrowerName: 'Ольга Руснак', dueDate: '30.11.2026', status: 'Выдана'),
    Loan(id: 'l10', bookTitle: 'Три товарища', borrowerName: 'Сергей Кожокару', dueDate: '03.12.2026', status: 'Взята'),
    Loan(id: 'l11', bookTitle: 'Властелин колец: Братство кольца', borrowerName: 'Ирина Драган', dueDate: '08.12.2026', status: 'Выдана'),
    Loan(id: 'l12', bookTitle: 'Маленький принц', borrowerName: 'Павел Чеботарь', dueDate: '10.12.2026', status: 'Взята'),
  ];
}
