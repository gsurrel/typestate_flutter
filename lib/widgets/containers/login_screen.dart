import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/widgets/invalid_user_state.dart';

@immutable
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: switch (userState) {
          UserProviderState(state: LoggedOut()) => ElevatedButton(
              onPressed: userState.login,
              child: const Text('Login'),
            ),
          UserProviderState(state: LoggedInValid()) =>
            const InvalidUserState.invalidVariant(),
          UserProviderState(state: LoggedInExpired()) =>
            const InvalidUserState.invalidVariant(),
          null => const InvalidUserState.nullState(),
        },
      ),
    );
  }
}
