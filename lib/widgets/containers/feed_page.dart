import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/widgets/feed_item.dart';

@immutable
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);

    return switch (userState) {
      UserProviderState(state: LoggedInValid(posts: final posts)) => Scaffold(
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
      null => const Placeholder(child: Text('Unable to get user state.')),
      UserProviderState(state: LoggedOut()) =>
        const Text('Unsupported user state.'),
      UserProviderState(state: LoggedInExpired()) =>
        const Text('Unsupported user state.'),
    };
  }
}
