import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/book.dart';
import '../models/books_model.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({super.key});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  // 1. Ключ формы для запуска валидации
  final _formKey = GlobalKey<FormState>();

  // 2. Контроллеры полей формы
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  String _selectedStatus = 'Доступна';

  // 3. Кто создаёт контроллеры, тот их и освобождает
  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _genreCtrl.dispose();
    super.dispose();
  }

  // 4. Метод сохранения и валидации (Задание 6)
  Future<void> _save() async {
    // Если валидация не прошла — ошибки отрисуются под полями
    if (!_formKey.currentState!.validate()) return;

    final draft = Book(
      id: '', // временный id — настоящую идентичность даст хранилище
      ownerId: 'user1',
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      genre: _genreCtrl.text.trim().isEmpty ? 'Разное' : _genreCtrl.text.trim(),
      coverUrl: '',
      status: _selectedStatus,
    );

    final error = await context.read<BooksModel>().add(draft);
    if (!mounted) return; // C8: экран может умереть, пока запрос летит

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)), // данные остаются в полях
      );
      return;
    }

    context.pop(); // список позади УЖЕ вырос — без единого лишнего вызова
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить книгу'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Поле 1: Название книги (Обязательное)
            TextFormField(
              controller: _titleCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Название книги *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Название книги обязательно';
                }
                if (value.trim().length < 2) {
                  return 'Название должно содержать минимум 2 символа';
                }
                return null; // null = валидно
              },
            ),
            const SizedBox(height: 16),

            // Поле 2: Автор (Обязательное)
            TextFormField(
              controller: _authorCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Автор *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Укажите автора книги';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Поле 3: Жанр (Необязательное)
            TextFormField(
              controller: _genreCtrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Жанр',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Статус книги',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Доступна', child: Text('Доступна')),
                DropdownMenuItem(value: 'Выдана', child: Text('Выдана')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedStatus = val);
              },
              validator: (value) => value == null ? 'Выберите статус книги' : null,
            ),
            const SizedBox(height: 24),

            // Кнопка сохранения
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
