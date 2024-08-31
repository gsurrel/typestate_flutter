import 'package:flutter/material.dart';
import 'package:type_state_pattern/business/user_provider.dart';
import 'package:type_state_pattern/business/user_state.dart';
import 'package:type_state_pattern/entities/user.dart';
import 'package:type_state_pattern/widgets/invalid_user_state.dart';

@immutable
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for text fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _bioController;

  // Variable to hold the selected user role
  UserRole _selectedRole = UserRole.standard;

  // Flag to toggle between edit and view mode
  bool _isEditing = false;

  // Flag to track if user data has been loaded
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
  }

  void _loadUserData(User user) {
    if (!_isUserDataLoaded) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _bioController.text = user.bio;
      _selectedRole = user.role;
      _isUserDataLoaded = true;
    }
  }

  void _saveProfile() {
    final userState = UserProvider.maybeOf(context);
    if (userState case UserProviderState(:final UserProfileMixin state)) {
      state.user = state.user.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        bio: _bioController.text,
        role: _selectedRole,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() => _isEditing = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = UserProvider.maybeOf(context);
    if (userState
        case UserProviderState(state: UserProfileMixin(:final user))) {
      // if (_isEditing)
      _loadUserData(user);

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<UserRole>(
                      segments: UserRole.values
                          .map(
                            (UserRole role) => ButtonSegment<UserRole>(
                              value: role,
                              label: Text(role.name),
                            ),
                          )
                          .toList(),
                      selected: {_selectedRole},
                      onSelectionChanged: _isEditing
                          ? (Set<UserRole> newSelection) {
                              setState(
                                () => _selectedRole = newSelection.first,
                              );
                            }
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isEditing
                          ? _saveProfile
                          : () => setState(() => _isEditing = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Save Changes' : 'Edit Profile',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (userState == null) {
      return const InvalidUserState.nullState();
    } else {
      return const InvalidUserState.invalidVariant();
    }
  }
}
