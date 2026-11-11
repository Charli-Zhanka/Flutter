import 'dart:async';
import 'package:flutter/material.dart';
import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});
  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _selectedTab = 0; // 0 - StreamBuilder, 1 - Listen

  // Для версии A
  late final Stream<int> _stream = countdown(10);

  // Для версии B
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) {
      if (mounted) setState(() => _left = i);
    });
  }

  @override
  void dispose() {
    _sub.cancel(); // ОБЯЗАТЕЛЬНО
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Version A (Builder)')),
                ButtonSegment(value: 1, label: Text('Version B (Listen)')),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (v) => setState(() => _selectedTab = v.first),
            ),
          ),
          Expanded(
            child: Center(
              child: _selectedTab == 0
                  ? StreamBuilder<int>(
                stream: _stream,
                builder: (context, snapshot) {
                  final value = snapshot.data ?? 10;
                  return Text('$value', style: Theme.of(context).textTheme.displayLarge);
                },
              )
                  : Text('$_left', style: Theme.of(context).textTheme.displayLarge),
            ),
          ),
        ],
      ),
    );
  }
}