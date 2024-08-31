import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/entities/post.dart';
import 'package:type_state_pattern/entities/user.dart';
import 'package:type_state_pattern/widgets/user_avatar.dart';

@immutable
class FeedItem extends StatefulWidget {
  const FeedItem(this.item, {super.key});

  final Post item;

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> with TickerProviderStateMixin {
  late final AnimationController _repostController = AnimationController(
    duration: Durations.short2,
    vsync: this,
  );

  late final AnimationController _favoriteController = AnimationController(
    duration: Durations.short2,
    vsync: this,
  );

  late final AnimationController _deleteController = AnimationController(
    duration: Durations.short2,
    vsync: this,
  );

  @override
  void dispose() {
    _repostController.dispose();
    _favoriteController.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  void _onRepost() {
    _repostController.forward().then((_) => _repostController.reverse());
    final userState = UserProvider.maybeOf(context);
    if (userState case UserProviderState(state: final LoggedInValid state)) {
      state.repost(widget.item);
    }
  }

  void _onFavorite() {
    _favoriteController.forward().then((_) => _favoriteController.reverse());
    final userState = UserProvider.maybeOf(context);
    if (userState case UserProviderState(state: final LoggedInValid state)) {
      state.favorite(widget.item);
    }
  }

  void _onDelete() {
    _deleteController.forward().then((_) => _deleteController.reverse());
    final userState = UserProvider.maybeOf(context);
    if (userState case UserProviderState(state: final LoggedInValid state)) {
      state.delete(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(name: widget.item.author),
                const SizedBox(width: 8),
                Text(
                  widget.item.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(widget.item.dateTime),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.item.text),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 0.2).animate(
                    CurvedAnimation(
                      parent: _repostController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      widget.item.isReposted
                          ? Icons.published_with_changes
                          : Icons.autorenew,
                      color:
                          widget.item.isReposted ? Colors.teal : Colors.black,
                    ),
                    onPressed: _onRepost,
                  ),
                ),
                ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 0.2).animate(
                    CurvedAnimation(
                      parent: _favoriteController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      widget.item.isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          widget.item.isFavorited ? Colors.teal : Colors.black,
                    ),
                    onPressed: _onFavorite,
                  ),
                ),
                if (userState
                    case UserProviderState(
                      state: UserProfileMixin(user: User(:final role))
                    ) when role == UserRole.admin)
                  ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 0).animate(
                      CurvedAnimation(
                        parent: _deleteController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _onDelete,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to format the time ago
  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s ago';
    } else {
      return '${seconds}s ago';
    }
  }
}
