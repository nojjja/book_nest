import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/my_library_screen.dart';
import 'screens/community_books_screen.dart';
import 'screens/my_loans_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/book_details_screen.dart';
import 'screens/edit_book_screen.dart';
import 'widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/login', // Стартуем с экрана аутентификации
  routes: [
    // ВНЕ shell-а (без нижней навигационной панели)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // ВНУТРИ shell-а (постоянная панель NavigationBar)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // Вкладка 1: Моя библиотека
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const MyLibraryScreen(),
              routes: [
                // ФИКСИРОВАННЫЙ маршрут перед переменным :id!
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const EditBookScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return BookDetailsScreen(id: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Вкладка 2: Сообщество
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/community',
              builder: (context, state) => const CommunityBooksScreen(),
            ),
          ],
        ),

        // Вкладка 3: Обмены
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/loans',
              builder: (context, state) => const MyLoansScreen(),
            ),
          ],
        ),

        // Вкладка 4: Профиль
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);