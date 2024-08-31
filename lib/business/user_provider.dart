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
    if (_session.state case final LoginMixin state) {
      setState(() => _session.state = state.login());
    }
  }

  void logout() {
    if (_session.state case final LogoutMixin state) {
      setState(() => _session.state = state.logout());
    }
  }

  void expireSession() {
    if (_session.state case final LoggedInValid state) {
      setState(() => _session.state = state.expireSession());
    }
  }

  void refreshToken() {
    if (_session.state case final LoggedInValid state) {
      setState(state.refreshToken);
    }
  }

  void favorite(Post item) {
    if (_session.state case final LoggedInValid state) {
      setState(() => state.favorite(item));
    }
  }

  void repost(Post item) {
    if (_session.state case final LoggedInValid state) {
      setState(() => state.repost(item));
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
