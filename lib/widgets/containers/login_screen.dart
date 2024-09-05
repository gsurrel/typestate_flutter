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
    return switch (userState) {
      UserProviderState(state: final LoginMixin state) => Scaffold(
          appBar: AppBar(
            title: const Text('Login Screen'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: state.login,
              child: const Text('Login'),
            ),
          ),
        ),
      null => const InvalidUserState.nullState(),
      _ => const InvalidUserState.invalidVariant(),
    };
  }
}
