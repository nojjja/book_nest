import 'package:flutter/material.dart';

import 'community_books_screen.dart';
import 'my_library_screen.dart';
import 'my_loans_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MyLibraryScreen(),
    CommunityBooksScreen(),
    MyLoansScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Библиотека',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Каталог',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Обмены',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
