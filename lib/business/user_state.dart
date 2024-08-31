import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:type_state_pattern/entities/post.dart';
import 'package:type_state_pattern/statics.dart';

/// Represents a token for user authentication.
typedef Token = String;

/// Represents the base class for user states.
sealed class UserState extends ChangeNotifier {
  // Private methods for state transitions.
  LoggedInValid _login() => LoggedInValid(token: 'foobar');
  LoggedOut _logout() => LoggedOut();
  LoggedInExpired _expireSession() => LoggedInExpired();
}

/// Represents the logged-out state of a user.
class LoggedOut extends UserState {
  LoggedInValid login() => _login();
}

/// Represents the logged-in state of a user with a valid session.
class LoggedInValid extends UserState {
  LoggedInValid({required Token token}) : _token = token {
    Statics.generateInitialFeedItems();
    _startPostTimer();
  }

  Token _token;

  final List<Post> _posts = Statics.generateInitialFeedItems();

  LoggedOut logout() => _logout();

  LoggedInExpired expireSession() => _expireSession();

  void refreshToken() {
    _token = _token.split('').reversed.join();
    notifyListeners();
  }

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

/// Represents the logged-in state of a user with an expired session.
class LoggedInExpired extends UserState {
  LoggedInExpired();

  LoggedOut logout() => _logout();
  LoggedInValid login() => _login();
}

/// Class to manage user sessions.
class UserSession<S extends UserState> extends ChangeNotifier {
  UserSession(this._state) {
    _state.addListener(_onStateChanged);
  }

  S get state => _state;
  S _state;
  set state(S state) {
    _state.removeListener(_onStateChanged);
    _state = state;
    _state.addListener(_onStateChanged);
  }

  // Forward changes to the UI.
  void _onStateChanged() => notifyListeners();
}
