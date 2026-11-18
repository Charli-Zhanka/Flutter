import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'error_text.dart';
import 'user.dart';
import 'users_model.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();

  bool _sending = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_sending) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final model = context.read<UsersModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _sending = true);
    final error = await model.add(
      User.draft(
        name: _name.text.trim(),
        username: _username.text.trim(),
        email: _email.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _sending = false);

    if (error == null) {
      navigator.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(errorText(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
              textInputAction: TextInputAction.next,
              validator: (v) {
                final s = v?.trim() ?? '';
                if (s.isEmpty) return 'Enter a username';
                if (s.contains(' ')) return 'No spaces';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  _emailRe.hasMatch(v?.trim() ?? '') ? null : 'Invalid email',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _sending ? null : _save,
              child: _sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
