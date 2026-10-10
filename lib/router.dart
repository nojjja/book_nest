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
  initialLocation: '/login', // Старт с экрана входа
  routes: [
    // 1. Маршрут ВНЕ shell-а (у экрана входа нет нижней панели)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // 2. Постоянная оболочка вкладок через indexedStack
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // Ветка 1: Моя библиотека (с под-маршрутами формы и деталей)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const MyLibraryScreen(),
              routes: [
                // Относительный путь: /library/add (ФИКСИРОВАННЫЙ — перед :id!)
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const EditBookScreen(),
                ),
                // Относительный путь: /library/:id
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

        // Ветка 2: Книги сообщества
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/community',
              builder: (context, state) => const CommunityBooksScreen(),
            ),
          ],
        ),

        // Ветка 3: Мои обмены
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/loans',
              builder: (context, state) => const MyLoansScreen(),
            ),
          ],
        ),

        // Ветка 4: Профиль пользователя
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