import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../users/users_model.dart';
import 'settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsModel>();
    final users = context.watch<UsersModel>().items;
    final cities = {for (final u in users) u.city}.toList()..sort();
    final selected = cities.contains(s.city) ? s.city : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: s.dark,
            onChanged: s.setDark,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String?>(
              initialValue: selected,
              decoration: const InputDecoration(labelText: 'City filter'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All cities'),
                ),
                for (final c in cities)
                  DropdownMenuItem<String?>(value: c, child: Text(c)),
              ],
              onChanged: s.setCity,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () {
              final auth = context.read<AuthModel>();
              Navigator.of(context).popUntil((r) => r.isFirst);
              auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
