import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:type_state_pattern/entities/post.dart';
import 'package:type_state_pattern/entities/user.dart';
import 'package:type_state_pattern/statics.dart';

/// Mixin for logging in.
mixin LoginMixin on UserState {
  void login() => super._session._state = LoggedInSessionUnlocked(_session);
}

/// Mixin for logging out.
mixin LogoutMixin on UserState {
  void logout() => super._session._state = LoggedOut(_session);
}

/// Mixin for locking a session.
mixin LockSessionMixin on UserState {
  void lockSession() => super._session._state = LoggedInSessionLocked(_session);
}

/// Mixin for user info.
mixin UserProfileMixin on UserState {
  User get user => _user;
  User _user = const User(
    name: 'John Doe',
    email: 'john.doe@example.com',
    bio: 'Flutter enthusiast and developer.',
  );
  set user(User user) {
    _user = user;
    notifyListeners();
  }
}

/// Represents the base class for user states.
sealed class UserState with ChangeNotifier {
  UserState(this._session);

  final UserSession _session;
}

/// Represents the logged-out state of a user.
class LoggedOut extends UserState with LoginMixin {
  LoggedOut(super.session);
}

/// Represents the logged-in state of a user with an unlocked session.
class LoggedInSessionUnlocked extends UserState
    with LogoutMixin, LockSessionMixin, UserProfileMixin {
  LoggedInSessionUnlocked(super._session) {
    Statics.generateInitialFeedItems();
    _startPostTimer();
  }

  final List<Post> _posts = Statics.generateInitialFeedItems();

  void favorite(Post post) {
    final index = _posts.indexWhere((element) => element == post);
    if (index != -1) {
      final updatedItem = _posts[index].copyWith(
        isFavorited: !_posts[index].isFavorited,
      );
      _posts[index] = updatedItem;
      notifyListeners();
    }
  }

  void repost(Post item) {
    final index = _posts.indexWhere((element) => element == item);
    if (index != -1) {
      final updatedItem = _posts[index].copyWith(
        isReposted: !_posts[index].isReposted,
      );
      _posts[index] = updatedItem;
      notifyListeners();
    }
  }

  void delete(Post item) {
    _posts.remove(item);
    notifyListeners();
  }

  List<Post> get posts => List.unmodifiable(_posts);

  // Timer to prepend a new post every random interval (2 to 8 seconds)
  void _startPostTimer() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      final random = Random();
      final interval = random.nextInt(7) + 2;
      Timer(Duration(seconds: interval), _prependNewPost);
    });
  }

  // Function to prepend a new post
  void _prependNewPost() {
    // Store the current DateTime
    _posts.insert(0, Statics.generatePost(DateTime.now()));

    notifyListeners();
  }
}

/// Represents the logged-in state of a user with an locked session.
class LoggedInSessionLocked extends UserState
    with LoginMixin, LogoutMixin, UserProfileMixin {
  LoggedInSessionLocked(super.session);
}

/// Class to manage user sessions.
class UserSession<S extends UserState> extends ChangeNotifier {
  UserSession() {
    _state.addListener(_onStateChanged);
  }

  S get state => _state;
  late S _state = LoggedOut(this) as S;
  set state(S state) {
    _state.removeListener(_onStateChanged);
    _state = state;
    _state.addListener(_onStateChanged);

    // Forward outer state changes to the UI.
    notifyListeners();
  }

  // Forward inner state changes to the UI.
  void _onStateChanged() => notifyListeners();
}
