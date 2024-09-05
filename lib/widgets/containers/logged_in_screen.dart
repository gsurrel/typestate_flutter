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
              if (state case LoginMixin())
                IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: state.login,
                ),
              if (state case LogoutMixin())
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: state.logout,
                ),
            ],
          ),
          body: switch (_selectedTab) {
            Tab.feed => const FeedPage(),
            Tab.profile => const ProfilePage(),
          },
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FeedTab(
                  badgeText: switch (state) {
                    LoggedInSessionUnlocked(:final posts)
                        when posts.isNotEmpty =>
                      posts.length.toString(),
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
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (state case final LockSessionMixin state)
                FloatingActionButton(
                  onPressed: state.lockSession,
                  tooltip: 'Lock session',
                  child: const Icon(Icons.lock),
                ),
            ]
                .expand(
                  (element) => [element, const SizedBox(width: 16)],
                )
                .toList(),
          ),
        ),
    };
  }
}

enum Tab {
  feed,
  profile,
}
