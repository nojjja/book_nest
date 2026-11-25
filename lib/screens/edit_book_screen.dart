import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/book.dart';
import '../models/books_model.dart';
import '../theme/app_theme.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({super.key, this.bookId});

  final String? bookId;

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  BookStatus _status = BookStatus.available;
  bool _loadedExistingBook = false;
  bool _saving = false;

  bool get _isEditing => widget.bookId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedExistingBook || widget.bookId == null) return;
    final book = context.read<BooksModel>().byId(widget.bookId!);
    if (book == null) return;
    _titleController.text = book.title;
    _authorController.text = book.author;
    _genreController.text = book.genre;
    _status = book.status;
    _loadedExistingBook = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Укажите название книги';
    if (value.trim().length < 2) return 'Нужно минимум два символа';
    return null;
  }

  String? _validateAuthor(String? value) {
    if (value == null || value.trim().isEmpty) return 'Укажите автора';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    final model = context.read<BooksModel>();
    final current = widget.bookId == null ? null : model.byId(widget.bookId!);
    final record = Book(
      id: current?.id ?? '',
      ownerId: current?.ownerId ?? 'user1',
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      genre: _genreController.text.trim().isEmpty
          ? 'Разное'
          : _genreController.text.trim(),
      coverUrl: current?.coverUrl ?? '',
      status: _status,
    );

    final error = current == null
        ? await model.add(record)
        : await model.update(record);
    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать запись' : 'Новая запись'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          children: [
            Text(
              _isEditing ? 'ИЗМЕНИТЬ КАТАЛОГОВЫЕ ДАННЫЕ' : 'ПОПОЛНИТЬ АРХИВ',
              style: AppTheme.mono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.charcoalMuted,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              style: AppTheme.serifHeading(fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'Название книги *',
                hintText: 'Например, «Мастер и Маргарита»',
              ),
              validator: _validateTitle,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _authorController,
              textInputAction: TextInputAction.next,
              style: AppTheme.sans(fontSize: 15),
              decoration: const InputDecoration(
                labelText: 'Автор *',
                hintText: 'Имя автора',
              ),
              validator: _validateAuthor,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _genreController,
              textInputAction: TextInputAction.done,
              style: AppTheme.sans(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Жанр',
                hintText: 'Например, классика',
              ),
            ),
            const SizedBox(height: 19),
            DropdownButtonFormField<BookStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Статус экземпляра'),
              items: const [
                DropdownMenuItem<BookStatus>(
                  value: BookStatus.available,
                  child: Text('Доступна'),
                ),
                DropdownMenuItem<BookStatus>(
                  value: BookStatus.loaned,
                  child: Text('Выдана'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
              validator: (value) =>
                  value == null ? 'Выберите статус экземпляра' : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.forestEmerald,
                  foregroundColor: AppTheme.paper,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  _saving ? 'СОХРАНЯЕМ…' : 'СОХРАНИТЬ В АРХИВ',
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.paper,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
