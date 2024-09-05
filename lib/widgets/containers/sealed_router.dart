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
    // Fetch the `UserState` (if available).
    final userState = UserProvider.maybeOf(context);
    return switch (userState?.state) {
      // First the sealed class `extends`.
      LoggedInSessionLocked() => const LoggedInScreen(),
      LoggedInSessionUnlocked() => const LoggedInScreen(),
      LoggedOut() => const LoginScreen(),
      // Then the case where no state was found in the widget tree.
      null => const InvalidUserState.nullState(),
      // Last, the available mixins `with`.
      LockSessionMixin() => const InvalidUserState.invalidVariant(),
      LoginMixin() => const InvalidUserState.invalidVariant(),
      LogoutMixin() => const InvalidUserState.invalidVariant(),
      UserProfileMixin() => const InvalidUserState.invalidVariant(),
    };
  }
}
