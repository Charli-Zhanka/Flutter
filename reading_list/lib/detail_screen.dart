import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  Future<void> _deleteBook(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm deletion'),
        content: Text('Delete \'${book.title}\'?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      Navigator.of(context).pop(BookAction.delete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Book details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Author: ${book.author}'),
            const SizedBox(height: 8),
            Text('Pages: ${book.pages}'),
            const SizedBox(height: 8),
            Text('Year: ${book.year ?? 'unknown'}'),
            const SizedBox(height: 8),
            Text('Read: ${book.read ? 'Yes' : 'No'}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(BookAction.toggleRead);
                },
                child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _deleteBook(context),
                child: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
