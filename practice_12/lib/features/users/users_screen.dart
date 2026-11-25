import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';
import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(context.read<UsersModel>().load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    final city = context.watch<SettingsModel>().city;
    final shown = city == null
        ? model.items
        : model.items.where((u) => u.city == city).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: _body(model, shown),
    );
  }

  Widget _body(UsersModel model, List<User> users) {
    if (model.items.isEmpty) {
      if (model.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (model.offline || model.error != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64),
              const SizedBox(height: 12),
              Text(
                model.offline
                    ? 'Offline — no saved data'
                    : 'Error: ${model.error}',
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: model.load, child: const Text('Retry')),
            ],
          ),
        );
      }
    }
    return Column(
      children: [
        if (model.fromCache)
          MaterialBanner(
            content: const Text('Saved data · no connection'),
            actions: [
              TextButton(onPressed: model.load, child: const Text('Retry')),
            ],
          ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.name),
                subtitle: Text('${u.email} · ${u.city}'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => UserDetailScreen(user: u),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
