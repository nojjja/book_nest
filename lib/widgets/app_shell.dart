import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/loans_model.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // Отображает содержимое текущей активной вкладки
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index), // Автоматически переключает ветку
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Библиотека',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Сообщество',
          ),
          NavigationDestination(
            icon: Consumer<LoansModel>(
              builder: (context, loans, child) => Badge(
                isLabelVisible: loans.count > 0,
                label: Text('${loans.count}'),
                child: child!,
              ),
              child: const Icon(Icons.swap_horiz_outlined),
            ),
            selectedIcon: const Icon(Icons.swap_horiz),
            label: 'Обмены',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
