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
    if (userState
        case UserProviderState(
          state: final LoginMixin state,
          :final session,
        )) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => state.login(session),
            child: const Text('Login'),
          ),
        ),
      );
    } else if (userState == null) {
      return const InvalidUserState.nullState();
    } else {
      return const InvalidUserState.invalidVariant();
    }
  }
}
