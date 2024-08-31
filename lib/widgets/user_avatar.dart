import 'package:flutter/material.dart';

@immutable
class UserAvatar extends StatelessWidget {
  const UserAvatar({
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
