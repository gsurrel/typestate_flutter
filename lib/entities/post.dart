import 'package:flutter/foundation.dart';

@immutable
class Post {
  const Post({
    required this.author,
    required this.dateTime,
    required this.text,
    this.isFavorited = false,
    this.isReposted = false,
  });

  final String author;
  final DateTime dateTime;
  final String text;
  final bool isFavorited;
  final bool isReposted;

  // CopyWith method
  Post copyWith({
    String? author,
    DateTime? dateTime,
    String? text,
    bool? isFavorited,
    bool? isReposted,
  }) =>
      Post(
        author: author ?? this.author,
        dateTime: dateTime ?? this.dateTime,
        text: text ?? this.text,
        isFavorited: isFavorited ?? this.isFavorited,
        isReposted: isReposted ?? this.isReposted,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Post) return false;
    return dateTime == other.dateTime;
  }

  @override
  int get hashCode => dateTime.hashCode;
}
