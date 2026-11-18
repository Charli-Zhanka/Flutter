import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final a = user.address;
    final website = user.website;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          _Row(Icons.badge_outlined, 'Username', user.username),
          _Row(Icons.email_outlined, 'Email', user.email),
          _Row(Icons.phone_outlined, 'Phone', user.phone, onTap: () {}),
          _Row(
            Icons.language,
            'Website',
            website ?? 'not provided',
            onTap: website == null ? null : () {},
          ),
          const Divider(),
          _Row(Icons.home_outlined, 'Address',
              '${a.street}, ${a.suite}\n${a.city}, ${a.zipcode}'),
          _Row(Icons.place_outlined, 'Geo', '${a.geo.lat}, ${a.geo.lng}'),
          const Divider(),
          _Row(Icons.business_outlined, 'Company', user.company.name),
          _Row(Icons.format_quote, 'Catch phrase', user.company.catchPhrase),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.icon, this.label, this.value, {this.onTap});

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon),
        title: Text(value),
        subtitle: Text(label),
        onTap: onTap,
      );
}
