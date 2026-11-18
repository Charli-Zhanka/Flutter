import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'new_user_screen.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();

    final Widget body;
    if (m.loading && m.items.isEmpty) {
      body = const LoadingView();
    } else {
      body = switch (m.error) {
        null => UserList(m.items),
        NoConnectionException() => Offline(onRetry: m.load),
        NotFoundException() || UnauthorizedException() => MessageView(
            icon: Icons.lock_outline,
            text: 'The server refused this request.',
            onRetry: m.load,
          ),
        ServerException(:final status) => ServerError(status, onRetry: m.load),
        BadResponseException() => const GenericError(),
      };
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: body,
      floatingActionButton: FloatingActionButton(
        tooltip: 'New user',
        onPressed: () => unawaited(
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const NewUserScreen()),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList(this.users, {super.key});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    final m = context.read<UsersModel>();
    return RefreshIndicator(
      onRefresh: m.load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final u = users[i];
          return ListTile(
            title: Text(u.name),
            subtitle: Text('${u.email}\n${u.address.city}'),
            isThreeLine: true,
            onTap: () => unawaited(
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UserDetailScreen(user: u),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.text,
    this.onRetry,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56),
              const SizedBox(height: 16),
              Text(text, textAlign: TextAlign.center),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                FilledButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ],
          ),
        ),
      );
}

class Offline extends StatelessWidget {
  const Offline({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
        icon: Icons.wifi_off,
        text: 'No connection.\nCheck your network and try again.',
        onRetry: onRetry,
      );
}

class ServerError extends StatelessWidget {
  const ServerError(this.status, {super.key, required this.onRetry});

  final int status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
        icon: Icons.cloud_off,
        text: 'The server had a problem ($status).',
        onRetry: onRetry,
      );
}

class GenericError extends StatelessWidget {
  const GenericError({super.key});

  @override
  Widget build(BuildContext context) => const MessageView(
        icon: Icons.bug_report_outlined,
        text: 'We could not read the server\'s answer.',
      );
}
