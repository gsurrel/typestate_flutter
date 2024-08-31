import 'package:flutter/material.dart';

@immutable
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _bio = 'Flutter enthusiast and developer.';

  // Controllers for text fields
  late final TextEditingController _nameController = TextEditingController()
    ..text = _name;
  late final TextEditingController _emailController = TextEditingController()
    ..text = _email;
  late final TextEditingController _bioController = TextEditingController()
    ..text = _bio;

  // Animation controller
  late final AnimationController _animationController = AnimationController(
    duration: Durations.medium1,
    vsync: this,
  );

  // State to track view/edit mode
  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      _isEditing
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  void _saveProfile() {
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      _bio = _bioController.text;
      _isEditing = false;
      _animationController.reverse();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Stack(
            children: [
              // Card for displaying profile information
              FadeTransition(
                opacity: _animationController.drive(
                  Tween<double>(begin: 1, end: 0),
                ),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Name: $_name',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: $_email',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bio: $_bio',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Card for editing profile information
              FadeTransition(
                opacity: _animationController.drive(
                  Tween<double>(begin: 0, end: 1),
                ),
                child: Card(
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
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Button color
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Edit/Save button in the top right corner
              Positioned(
                right: 16,
                top: 16,
                child: IconButton(
                  icon: Icon(_isEditing ? Icons.remove_red_eye : Icons.edit),
                  onPressed: _toggleEdit,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
