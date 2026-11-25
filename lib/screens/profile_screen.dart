import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/loan.dart';
import '../data/network_failure_controller.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../theme/app_theme.dart';
import '../widgets/error_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _simulateError = false;

  void _setSimulateError(BuildContext context, bool value) {
    setState(() => _simulateError = value);
    context.read<NetworkFailureController>().setEnabled(value);
    context.read<BooksModel>().load();
    context.read<LoansModel>().load();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.paper,
        title: Text('Выйти из архива?', style: AppTheme.serifHeading()),
        content: Text(
          'Для входа понадобится снова открыть учётную запись.',
          style: AppTheme.sans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('ОСТАТЬСЯ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('ВЫЙТИ'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksModel>();
    final loans = context.watch<LoansModel>();
    final activeLoans = loans.items
        .where((loan) => loan.status == LoanStatus.active)
        .length;
    final isLoading = books.isLoading || loans.isLoading;
    final loadError = books.error ?? loans.error;

    if (isLoading || loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Профиль')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.forestEmerald,
                          strokeWidth: 1.5,
                        ),
                      )
                    : ErrorView(
                        message: loadError!,
                        onRetry: () {
                          context.read<BooksModel>().load();
                          context.read<LoansModel>().load();
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Симулировать сбой сети',
                        style: AppTheme.sans(fontSize: 13),
                      ),
                    ),
                    Switch(
                      value: _simulateError,
                      activeThumbColor: AppTheme.waxTerracotta,
                      onChanged: (value) => _setSimulateError(context, value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        children: [
          Text(
            'ЧИТАТЕЛЬСКИЙ БИЛЕТ  /  04',
            style: AppTheme.mono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.charcoalMuted,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.hairline),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 34,
                color: AppTheme.forestEmerald,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'Надежда',
            textAlign: TextAlign.center,
            style: AppTheme.serifHeading(
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'СТУДЕНТ  ·  ТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ МОЛДОВЫ',
            textAlign: TextAlign.center,
            style: AppTheme.mono(
              fontSize: 8,
              color: AppTheme.charcoalMuted,
              letterSpacing: .45,
            ),
          ),
          const SizedBox(height: 25),
          const Divider(height: 1, color: AppTheme.hairline),
          _ProfileStat(
            number: books.myBooks.length.toString().padLeft(2, '0'),
            label: 'КНИГ В ЛИЧНОМ ФОНДЕ',
          ),
          const Divider(height: 1, color: AppTheme.hairline),
          _ProfileStat(
            number: activeLoans.toString().padLeft(2, '0'),
            label: 'АКТИВНЫХ ОБМЕНОВ',
          ),
          const Divider(height: 1, color: AppTheme.hairline),
          const SizedBox(height: 24),
          Text(
            'СЕТЬ И СИНХРОНИЗАЦИЯ',
            style: AppTheme.mono(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppTheme.charcoalMuted,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Симулировать сбой сети',
                  style: AppTheme.sans(fontSize: 14),
                ),
              ),
              Switch(
                value: _simulateError,
                activeThumbColor: AppTheme.waxTerracotta,
                onChanged: (value) => _setSimulateError(context, value),
              ),
            ],
          ),
          Text(
            'Показывать архивное сообщение при недоступном хранилище.',
            style: AppTheme.sans(fontSize: 11, color: AppTheme.charcoalMuted),
          ),
          const SizedBox(height: 35),
          OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, size: 17),
            label: Text(
              'ВЫЙТИ ИЗ АККАУНТА',
              style: AppTheme.mono(fontSize: 10, fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.waxTerracotta,
              side: const BorderSide(color: AppTheme.hairline),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTheme.mono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.charcoalMuted,
              ),
            ),
          ),
          Text(
            number,
            style: AppTheme.serifHeading(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.forestEmerald,
            ),
          ),
        ],
      ),
    );
  }
}
