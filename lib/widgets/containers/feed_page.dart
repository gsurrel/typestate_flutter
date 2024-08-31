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

    if (userState
        case UserProviderState(
          state: LoggedInValid(posts: final posts),
        )) {
      return Scaffold(
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
      );
    } else if (userState case UserProviderState(state: LoggedInExpired())) {
      return const Center(
        child: Text(
          'Feed is disabled because your access token '
          'has expired. Log-in to access your feed.',
          textAlign: TextAlign.center,
        ),
      );
    } else if (userState == null) {
      return const InvalidUserState.nullState();
    } else {
      return const InvalidUserState.invalidVariant();
    }
  }
}
