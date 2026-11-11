import 'package:flutter/material.dart';
import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    ),
    home: const SignUpScreen(),
  );
}

const groups = [
  'IT-2301',
  'IT-2302',
  'IT-2303',
  'IT-2304',
  'IT-2305',
];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;
  int _passwordLength = 0;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _birthController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _done = true;
      });
    }
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _birth = picked;
      _birthController.text =
      '${picked.day.toString().padLeft(2, '0')}.'
          '${picked.month.toString().padLeft(2, '0')}.'
          '${picked.year}';
    });
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthController.clear();

      _group = null;
      _birth = null;
      _agreed = false;
      _passwordLength = 0;
      _done = false;
    });
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            onFieldSubmitted: (_) {
              _emailFocus.requestFocus();
            },
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (v) {
              final value = (v ?? '').trim();
              return value.length < 2
                  ? 'Name must be at least 2 characters'
                  : null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _email,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'name@kbtu.kz',
            ),
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (v) {
              final value = (v ?? '').trim();
              final at = value.indexOf('@');

              return at < 1 || value.indexOf('.', at) < at + 2
                  ? 'Enter a valid email'
                  : null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Password',
              helperText: 'At least 8 characters',
            ),
            onChanged: (value) {
              setState(() {
                _passwordLength = value.length;
              });
            },
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (v) {
              return (v ?? '').length < 8
                  ? 'Password must be at least 8 characters'
                  : null;
            },
          ),
          Text('$_passwordLength of 8'),
          const SizedBox(height: 12),

          TextFormField(
            controller: _confirm,
            obscureText: true,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Confirm password',
            ),
            onFieldSubmitted: (_) {
              if (_agreed) _signUp();
            },
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (v) {
              return (v ?? '') != _password.text
                  ? 'Passwords do not match'
                  : null;
            },
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _group,
            decoration: const InputDecoration(
              labelText: 'Group',
            ),
            items: [
              for (final group in groups)
                DropdownMenuItem(
                  value: group,
                  child: Text(group),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _group = value;
              });
            },
            validator: (value) {
              return value == null ? 'Choose a group' : null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _birthController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of birth',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _pickBirthDate,
            validator: (_) {
              return _birth == null
                  ? 'Choose your date of birth'
                  : null;
            },
          ),
          const SizedBox(height: 8),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('I agree to the rules'),
            value: _agreed,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                _agreed = value ?? false;
              });
            },
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: _agreed ? _signUp : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: SafeArea(
        child: _done
            ? SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SummaryCard(
                name: _name.text.trim(),
                email: _email.text.trim(),
                group: _group ?? '',
                birthDate: _birthController.text,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _startOver,
                child: const Text('Start over'),
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _buildForm(),
        ),
      ),
    );
  }
}
