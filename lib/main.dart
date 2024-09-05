import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/widgets/containers/sealed_router.dart';

void main() => runApp(
      // The usual root-level widget.
      const MaterialApp(
        // The widget providing the UserState downwards.
        home: UserProvider(
          child: SealedRouter(), // The widget handling which page to show.
        ),
      ),
    );
