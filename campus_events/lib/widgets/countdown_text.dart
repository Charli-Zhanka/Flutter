import 'dart:async';

import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  final DateTime eventDate;

  const CountdownText({
    super.key,
    required this.eventDate,
  });

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? timer;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    updateRemaining();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => updateRemaining(),
    );
  }

  void updateRemaining() {
    if (!mounted) return;

    setState(() {
      remaining = widget.eventDate.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (remaining.inSeconds <= 0) {
      return const Text(
        'The event has started or ended',
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time until event',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('$days days  $hours hours'),
            Text('$minutes minutes  $seconds seconds'),
          ],
        ),
      ),
    );
  }
}
