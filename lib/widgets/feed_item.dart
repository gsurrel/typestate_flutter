import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/entities/post.dart';

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

  @override
  void dispose() {
    _repostController.dispose();
    _favoriteController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MyAvatar(name: widget.item.author),
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
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
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

class MyAvatar extends StatelessWidget {
  const MyAvatar({
    required this.name,
    super.key,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        child: Text(
          String.fromCharCode(name.runes.first),
        ),
      ),
    );
  }
}
