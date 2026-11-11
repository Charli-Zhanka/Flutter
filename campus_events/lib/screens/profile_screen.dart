import 'package:flutter/material.dart';

import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile profile = Profile.empty();

  final nameController = TextEditingController();
  final groupController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    groupController.dispose();
    super.dispose();
  }

  void saveProfile() {
    setState(() {
      profile = profile.copyWith(
        name: nameController.text.trim(),
        group: groupController.text.trim(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Student name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: groupController,
          decoration: const InputDecoration(
            labelText: 'Group',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: saveProfile,
            child: const Text('Save Profile'),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        Text(
          'Your Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text('Name: ${profile.name.isEmpty ? 'Not set' : profile.name}'),
        const SizedBox(height: 8),
        Text('Group: ${profile.group.isEmpty ? 'Not set' : profile.group}'),
      ],
    );
  }
}