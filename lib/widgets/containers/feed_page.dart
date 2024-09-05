import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/widgets/feed_item.dart';
import 'package:type_state_pattern/widgets/invalid_user_state.dart';

@immutable
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);

    return switch (userState) {
      UserProviderState(state: LoggedInSessionUnlocked(:final posts)) =>
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Feed',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => FeedItem(posts[index]),
          ),
        ),
      UserProviderState(state: LoggedInSessionLocked()) => const Center(
          child: Text(
            'Feed is disabled because your session is locked. '
            'Log-in again to access your feed.',
            textAlign: TextAlign.center,
          ),
        ),
      null => const InvalidUserState.nullState(),
      _ => const InvalidUserState.invalidVariant()
    };
  }
}
