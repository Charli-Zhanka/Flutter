import 'category.dart';

class Item {
  final String title;
  final EventCategory category;
  final DateTime when;
  final int limit;
  final List<String> names;
  final bool mode;
  final String? description;
  final bool favourite;
  final String location;

  const Item({
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required this.names,
    required this.mode,
    required this.description,
    required this.favourite,
    required this.location,
  });

  factory Item.empty() {
    return Item(
      title: '',
      category: EventCategory.technology,
      when: DateTime.now(),
      limit: 10,
      names: const [],
      mode: false,
      description: null,
      favourite: false,
      location: '',
    );
  }

  int get count => names.length;

  int get freePlaces => limit - count;

  bool get isFull => count >= limit;

  bool get isPast => when.isBefore(DateTime.now());

  bool contains(String name) => names.contains(name);

  ({int taken, int free}) get places => (
  taken: count,
  free: freePlaces,
  );

  Item copyWith({
    String? title,
    EventCategory? category,
    DateTime? when,
    int? limit,
    List<String>? names,
    bool? mode,
    String? description,
    bool clearDescription = false,
    bool? favourite,
    String? location,
  }) {
    return Item(
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      limit: limit ?? this.limit,
      names: List.unmodifiable(names ?? this.names),
      mode: mode ?? this.mode,
      description: clearDescription
          ? null
          : description ?? this.description,
      favourite: favourite ?? this.favourite,
      location: location ?? this.location,
    );
  }
}
