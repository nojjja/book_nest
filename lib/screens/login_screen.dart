import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.go('/library');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 52,
                      color: AppTheme.forestEmerald,
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'BookNest',
                      textAlign: TextAlign.center,
                      style: AppTheme.serifHeading(
                        fontSize: 37,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'EX LIBRIS  ·  СТУДЕНЧЕСКИЙ КНИГООБМЕН',
                      textAlign: TextAlign.center,
                      style: AppTheme.mono(
                        fontSize: 8,
                        color: AppTheme.charcoalMuted,
                        letterSpacing: .65,
                      ),
                    ),
                    const SizedBox(height: 34),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: AppTheme.sans(fontSize: 15),
                      decoration: const InputDecoration(
                        labelText: 'Электронная почта',
                        hintText: 'name@university.md',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введите адрес электронной почты';
                        }
                        if (!value.trim().contains('@')) {
                          return 'Проверьте формат адреса';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      style: AppTheme.sans(fontSize: 15),
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        hintText: 'Не менее шести символов',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите пароль';
                        }
                        if (value.length < 6) {
                          return 'Нужно минимум шесть символов';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.forestEmerald,
                          foregroundColor: AppTheme.paper,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          'ВОЙТИ В АРХИВ',
                          style: AppTheme.mono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.paper,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Регистрация появится в следующем выпуске.',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'НЕТ БИЛЕТА? ЗАРЕГИСТРИРОВАТЬСЯ',
                          style: AppTheme.mono(
                            fontSize: 9,
                            color: AppTheme.charcoalMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
