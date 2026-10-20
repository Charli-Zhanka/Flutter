import 'package:flutter/material.dart';

import '../models/item.dart';
import '../utils/format.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavouriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(item.category.icon),
        ),
        title: Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.category.label),
            Text(formatDate(item.when)),
            Text('Places: ${item.count}/${item.limit}'),
          ],
        ),
        trailing: IconButton(
          onPressed: onFavouriteTap,
          icon: Icon(
            item.favourite
                ? Icons.favorite
                : Icons.favorite_border,
            color: item.favourite ? Colors.pink : null,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
