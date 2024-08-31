import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/widgets/containers/feed_page.dart';
import 'package:type_state_pattern/widgets/containers/profile_page.dart';
import 'package:type_state_pattern/widgets/feed_tab.dart';
import 'package:type_state_pattern/widgets/invalid_user_state.dart';

@immutable
class LoggedInScreen extends StatefulWidget {
  const LoggedInScreen({super.key});

  @override
  State<LoggedInScreen> createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  Tab _selectedTab = Tab.feed;

  void _onItemTapped(int index) {
    setState(() => _selectedTab = Tab.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);
    return switch (userState) {
      null => const InvalidUserState.nullState(),
      UserProviderState(state: LoggedOut()) =>
        const InvalidUserState.invalidVariant(),
      UserProviderState(:final state) => Scaffold(
          appBar: AppBar(
            title: const Text('Home Screen'),
            actions: [
              IconButton(
                icon: Icon(
                  switch (state) {
                    LoggedOut() => throw UnimplementedError(),
                    LoggedInValid() => Icons.logout,
                    LoggedInExpired() => Icons.login,
                  },
                ),
                onPressed: switch (state) {
                  LoggedOut() => throw UnimplementedError(),
                  LoggedInValid() => userState.logout,
                  LoggedInExpired() => userState.login,
                },
              ),
            ],
          ),
          body: switch (_selectedTab) {
            Tab.feed => switch (state) {
                LoggedOut() => throw UnimplementedError(),
                LoggedInValid() => const FeedPage(),
                LoggedInExpired() => const Center(
                    child: Text(
                      'Feed is disabled because your access token '
                      'has expired. Log-in to access your feed.',
                      textAlign: TextAlign.center,
                    ),
                  ),
              },
            Tab.profile => const ProfilePage(),
          },
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FeedTab(
                  badgeText: switch (state) {
                    LoggedInValid(posts: final feedItems)
                        when feedItems.isNotEmpty =>
                      feedItems.length.toString(),
                    _ => null,
                  },
                ),
                label: 'Feed',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedTab.index,
            onTap: _onItemTapped,
          ),
          floatingActionButton: switch (state) {
            LoggedOut() => const InvalidUserState.invalidVariant(),
            LoggedInValid() => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: userState.refreshToken,
                    tooltip: 'Refresh Token',
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: userState.expireSession,
                    tooltip: 'Expire Session',
                    child: const Icon(Icons.explicit),
                  ),
                ],
              ),
            LoggedInExpired() => null,
          },
        ),
    };
  }
}

enum Tab {
  feed,
  profile,
}
