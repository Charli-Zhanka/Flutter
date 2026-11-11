import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];

  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((book) => book.read).toList(),
  };

  Future<void> _openDetail(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );

    if (!mounted) return;

    switch (action) {
      case null:
        break;
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context)
        .push<Book>(MaterialPageRoute(builder: (_) => const AddBookScreen()));

    if (!mounted) return;
    if (book == null) return;

    setState(() => _books.add(book));
  }

  Widget _stat(String label, int value) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Text('$value', style: textTheme.headlineSmall),
          Text(label, style: textTheme.bodySmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _stat('Books', _books.length),
                    _stat('Pages', totalPages(_books)),
                    _stat('Unread', unread(_books).length),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final f in Filter.values)
                  ChoiceChip(
                    label: Text(switch (f) {
                      Filter.all => 'All',
                      Filter.unread => 'Unread',
                      Filter.read => 'Read',
                    }),
                    selected: _filter == f,
                    onSelected: (_) {
                      setState(() => _filter = f);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _visible.length,
                itemBuilder: (context, index) {
                  final book = _visible[index];

                  return BookTile(
                    book: book,
                    onToggle: () {
                      setState(() => book.read = !book.read);
                    },
                    onTap: () => _openDetail(book),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
