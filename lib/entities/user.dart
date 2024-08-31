import 'package:flutter/material.dart';

@immutable
class User {
  const User({
    required this.name,
    required this.email,
    required this.bio,
    this.role = UserRole.standard,
  });

  final String name;
  final String email;
  final String bio;
  final UserRole role;

  User copyWith({
    String? name,
    String? email,
    String? bio,
    UserRole? role,
  }) =>
      User(
        name: name ?? this.name,
        email: email ?? this.email,
        bio: bio ?? this.bio,
        role: role ?? this.role,
      );
}

enum UserRole { admin, standard }
