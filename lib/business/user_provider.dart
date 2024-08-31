import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/entities/post.dart';

@immutable
class UserProvider extends StatefulWidget {
  const UserProvider({required this.child, super.key});

  final Widget child;

  static UserProviderState? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<UserProviderInherited>()
      ?.userState;

  @override
  UserProviderState createState() => UserProviderState();
}

class UserProviderState extends State<UserProvider> {
  UserProviderState() {
    _session.addListener(_onUserStateChanged);
  }

  final UserSession<UserState> _session = UserSession(LoggedOut());

  void _onUserStateChanged() => setState(() {});

  void login() {
    final newState = switch (_session.state) {
      final LoggedInValid _ => null,
      final LoggedOut state => state.login(),
      final LoggedInExpired state => state.login(),
    };
    if (newState != null) setState(() => _session.state = newState);
  }

  void logout() {
    final newState = switch (_session.state) {
      final LoggedInValid state => state.logout(),
      final LoggedOut _ => null,
      final LoggedInExpired state => state.logout(),
    };
    if (newState != null) setState(() => _session.state = newState);
  }

  void expireSession() {
    final newState = switch (_session.state) {
      final LoggedInValid state => state.expireSession(),
      final LoggedOut _ => null,
      final LoggedInExpired _ => null,
    };
    if (newState != null) setState(() => _session.state = newState);
  }

  void refreshToken() {
    switch (_session.state) {
      case final LoggedInValid validState:
        setState(validState.refreshToken);
      case LoggedOut():
      case LoggedInExpired():
      // Invalid call
    }
  }

  void favorite(Post item) {
    switch (_session.state) {
      case final LoggedInValid validState:
        setState(() => validState.favorite(item));
      case LoggedOut():
      case LoggedInExpired():
      // Invalid call
    }
  }

  void repost(Post item) {
    switch (_session.state) {
      case final LoggedInValid validState:
        setState(() => validState.repost(item));
      case LoggedOut():
      case LoggedInExpired():
      // Invalid call
    }
  }

  UserState get state => _session.state;

  @override
  Widget build(BuildContext context) {
    return UserProviderInherited(
      userState: this,
      child: widget.child,
    );
  }
}

@immutable
class UserProviderInherited extends InheritedWidget {
  const UserProviderInherited({
    required this.userState,
    required super.child,
    super.key,
  });

  final UserProviderState userState;

  @override
  bool updateShouldNotify(UserProviderInherited oldWidget) => true;
}
