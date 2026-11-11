import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';
import '../widgets/countdown_text.dart';
import 'edit_event_screen.dart';

class DetailScreen extends StatefulWidget {
  final Item item;

  const DetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Future<void> editEvent() async {
    final updatedItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(item: item),
      ),
    );

    if (updatedItem != null && mounted) {
      Navigator.pop(context, updatedItem);
    }
  }

  Future<void> deleteEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event?'),
        content: const Text(
          'Are you sure you want to delete this event?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(context, 'delete');
    }
  }

  void joinEvent() {
    if (item.isFull || item.isPast || item.contains('Student')) {
      return;
    }

    final updatedItem = item.copyWith(
      names: [...item.names, 'Student'],
    );

    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    final alreadyJoined = item.contains('Student');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            onPressed: editEvent,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit event',
          ),
          IconButton(
            onPressed: deleteEvent,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete event',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Icon(
                    item.category.icon,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text('Category: ${item.category.label}'),
                const SizedBox(height: 8),
                Text('Date: ${formatDate(item.when)}'),
                const SizedBox(height: 8),
                Text('Location: ${item.location}'),
                const SizedBox(height: 8),
                Text(
                  'Participants: ${item.count}/${item.limit}',
                ),
                const SizedBox(height: 16),
                Text(
                  item.description ?? 'No description available',
                ),
                const SizedBox(height: 16),
                CountdownText(eventDate: item.when),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                item.isFull || item.isPast || alreadyJoined
                    ? null
                    : joinEvent,
                child: Text(
                  item.isFull
                      ? 'No places available'
                      : item.isPast
                      ? 'Event has ended'
                      : alreadyJoined
                      ? 'Already joined'
                      : 'Join event',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}