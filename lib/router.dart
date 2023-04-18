import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/video/views/video_recording_screen.dart';

import 'features/inbox/chats.screen.dart';

final routerProvider = Provider(
  (ref) {
    // ref.watch(authState); <= 이렇게 해주면 state의 변화가 있을때 아래 dependency에 변화가 있으니 provider가 rebuild됨.
    // 그럼 자동으로 redirct됨.

    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepository).isLoggedIn;
        if (!isLoggedIn &&
            state.subloc != SignUpScreen.routeURL &&
            state.subloc != LoginScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: InterestsScreen.routeName,
          path: InterestsScreen.routeURL,
          builder: (context, state) => const InterestsScreen(),
        ),
        GoRoute(
          path: '/:tab(home|discover|inbox|profile)',
          name: MainNavigationScreen.routeName,
          builder: (context, state) {
            final tab = state.params['tab']!;
            return MainNavigationScreen(
              tab: tab,
            );
          },
        ),
        GoRoute(
          name: ActivityScreen.routeName,
          path: ActivityScreen.routeUrl,
          builder: (context, state) => const ActivityScreen(),
        ),
        GoRoute(
          name: ChatsScreen.routeName,
          path: ChatsScreen.routeUrl,
          builder: (context, state) => const ChatsScreen(),
          routes: [
            GoRoute(
              name: ChatDetailScreen.routeName,
              path: ChatDetailScreen.routeUrl,
              builder: (context, state) {
                final chatId = state.params['chatId']!;
                return ChatDetailScreen(chatId: chatId);
              },
            ),
          ],
        ),
        GoRoute(
          name: VideoRecordingScreen.routeName,
          path: VideoRecordingScreen.routeUrl,
          builder: (context, state) => const VideoRecordingScreen(),
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            child: const VideoRecordingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final position =
                  Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(animation);
              return SlideTransition(
                position: position,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  },
);
