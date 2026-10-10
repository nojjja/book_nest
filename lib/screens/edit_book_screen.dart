import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  // 3. Кто создаёт контроллеры, тот их и освобождает
  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _genreCtrl.dispose();
    super.dispose();
  }

  // 4. Метод сохранения и валидации
  void _save() {
    // Если валидация не прошла — ошибки отрисуются под полями
    if (!_formKey.currentState!.validate()) return;

    // Валидация успешна — показываем фидбек и закрываем экран
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Книга сохранена: ${_titleCtrl.text.trim()}'),
      ),
    );

    // Экран был открыт через context.push('/library/add') -> закрываем через pop()
    context.pop();
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