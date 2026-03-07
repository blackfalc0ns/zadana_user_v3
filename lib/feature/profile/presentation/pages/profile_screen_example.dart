import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_screen.dart';

/// Example usage of the refactored ProfileScreen
/// 
/// The ProfileScreen now has zero callbacks and manages all state
/// internally using ProfileCubit.
/// 
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => const ProfileScreen(),
///   ),
/// );
/// ```
class ProfileScreenExample extends StatelessWidget {
  const ProfileScreenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          child: const Text('Open Profile Screen'),
        ),
      ),
    );
  }
}