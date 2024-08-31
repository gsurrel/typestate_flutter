import 'package:flutter/material.dart';

@immutable
class InvalidUserState extends StatelessWidget {
  const InvalidUserState.nullState({super.key})
      : message = 'User state not found';

  const InvalidUserState.invalidVariant({super.key})
      : message = 'User state is not valid';

  final String message;

  @override
  Widget build(BuildContext context) => Placeholder(child: Text(message));
}
