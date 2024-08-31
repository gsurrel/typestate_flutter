import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/widgets/containers/logged_in_screen.dart';
import 'package:type_state_pattern/widgets/containers/login_screen.dart';
import 'package:type_state_pattern/widgets/invalid_user_state.dart';

@immutable
class SealedRouter extends StatelessWidget {
  const SealedRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);
    return switch (userState?.state) {
      LoggedInValid() => const LoggedInScreen(),
      LoggedOut() => const LoginScreen(),
      LoggedInExpired() => const LoggedInScreen(),
      null => const InvalidUserState.nullState(),
    };
  }
}
