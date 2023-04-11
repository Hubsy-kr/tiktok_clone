import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends StatelessWidget {
  static String routeURL = "/";
  static String routeName = "signUp";

  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) {
    context.push(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     transitionDuration: const Duration(
    //       seconds: 1,
    //     ),
    //     reverseTransitionDuration: const Duration(
    //       seconds: 1,
    //     ),
    //     pageBuilder: (context, animation, secondaryAnimation) =>
    //         const UsernameScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) =>
    //         ScaleTransition(
    //       scale: animation,
    //       alignment: Alignment.bottomCenter,
    //       child: FadeTransition(
    //         opacity: animation,
    //         child: child,
    //       ),
    //     ),
    //   ),
    //   // MaterialPageRoute(
    //   //   builder: (context) => const UsernameScreen(),
    //   // ),
    // );

    //Navigator.of(context).pushNamed(UsernameScreen.routeName);

    context.push(UsernameScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  const Text(
                    'Sign up for TikTok',
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  Text(
                    'Create a profile, follow other accounts, make your own videos, and more.',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: isDarkMode(context)
                          ? Colors.grey.shade300
                          : Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.v40,
                  if (orientation == Orientation.portrait) ...[
                    GestureDetector(
                      onTap: () => _onEmailTap(context),
                      child: const AuthButton(
                          icon: FaIcon(FontAwesomeIcons.user),
                          text: 'Use email & password'),
                    ),
                    Gaps.v16,
                    const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.facebook),
                        text: 'Continue with Facebook'),
                    Gaps.v16,
                    const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.apple),
                        text: 'Continue with apple'),
                    Gaps.v16,
                    const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.google),
                        text: 'Continue with Google'),
                  ],
                  if (orientation == Orientation.landscape) ...[
                    Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onEmailTap(context),
                          child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.user),
                              text: 'Use email & password'),
                        ),
                      ),
                      Gaps.v16,
                      const Expanded(
                        child: AuthButton(
                            icon: FaIcon(FontAwesomeIcons.facebook),
                            text: 'Continue with Facebook'),
                      ),
                    ]),
                    // Gaps.h16,
                    // const Row(
                    //   children: [
                    //     Expanded(
                    //       child: AuthButton(
                    //           icon: FaIcon(FontAwesomeIcons.apple),
                    //           text: 'Continue with apple'),
                    //     ),
                    //     Gaps.v16,
                    //     Expanded(
                    //       child: AuthButton(
                    //           icon: FaIcon(FontAwesomeIcons.google),
                    //           text: 'Continue with Google'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDarkMode(context) ? null : Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size64,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
