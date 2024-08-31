import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_state.dart';

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
    _session.addListener(_onSessionChanged);
  }

  UserSession get session => _session;
  final UserSession<UserState> _session = UserSession(LoggedOut());

  UserState get state => _session.state;

  void _onSessionChanged() => setState(() {});

  @override
  Widget build(BuildContext context) => UserProviderInherited(
        userState: this,
        child: widget.child,
      );
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
