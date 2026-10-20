import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/category.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import 'add_event_screen.dart';
import 'detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Item> items;

  int selectedIndex = 0;
  String searchQuery = '';
  EventCategory? selectedCategory;
  String selectedTimeFilter = 'All';

  @override
  void initState() {
    super.initState();
    items = List<Item>.from(seedItems);
  }

  Future<void> addEvent() async {
    final event = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      ),
    );

    if (event != null && mounted) {
      setState(() {
        items.insert(0, event);
        selectedIndex = 0;
        searchQuery = '';
        selectedCategory = null;
        selectedTimeFilter = 'All';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created')),
      );
    }
  }

  Future<void> openDetails(Item item) async {
    final result = await Navigator.push<Object>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item),
      ),
    );

    if (!mounted) return;

    setState(() {
      if (result == 'delete') {
        items.remove(item);
      } else if (result is Item) {
        final index = items.indexOf(item);

        if (index != -1) {
          items[index] = result;
        }
      }
    });

    if (result == 'delete') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted')),
      );
    }
  }

  void toggleFavourite(Item item) {
    setState(() {
      final index = items.indexOf(item);

      if (index != -1) {
        items[index] = item.copyWith(
          favourite: !item.favourite,
        );
      }
    });
  }

  List<Item> get filteredItems {
    return items.where((item) {
      if (selectedIndex == 1 && !item.favourite) {
        return false;
      }

      final query = searchQuery.toLowerCase().trim();

      final matchesSearch =
          item.title.toLowerCase().contains(query) ||
              item.category.label.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == null ||
              item.category == selectedCategory;

      final matchesTime = switch (selectedTimeFilter) {
        'Upcoming' => !item.isPast,
        'Past' => item.isPast,
        _ => true,
      };

      return matchesSearch && matchesCategory && matchesTime;
    }).toList();
  }

  Widget buildEventsList() {
    final visibleItems = filteredItems;

    if (visibleItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No events found',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90, top: 4),
      itemCount: visibleItems.length,
      itemBuilder: (context, index) {
        final item = visibleItems[index];

        return ItemCard(
          item: item,
          onTap: () => openDetails(item),
          onFavouriteTap: () => toggleFavourite(item),
        );
      },
    );
  }

  Widget buildFilters() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                onPressed: () {
                  setState(() {
                    searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear),
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: ['All', 'Upcoming', 'Past'].map((filter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: selectedTimeFilter == filter,
                  onSelected: (_) {
                    setState(() {
                      selectedTimeFilter = filter;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              ChoiceChip(
                label: const Text('All categories'),
                selected: selectedCategory == null,
                onSelected: (_) {
                  setState(() {
                    selectedCategory = null;
                  });
                },
              ),
              ...EventCategory.values.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(category.label),
                    selected: selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory =
                        selectedCategory == category
                            ? null
                            : category;
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProfile = selectedIndex == 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (selectedIndex) {
            1 => 'Favourite Events',
            2 => 'My Profile',
            _ => 'Campus Events',
          },
        ),
      ),
      body: isProfile
          ? const ProfileScreen()
          : Column(
        children: [
          buildFilters(),
          Expanded(child: buildEventsList()),
        ],
      ),
      floatingActionButton: selectedIndex == 2
          ? null
          : FloatingActionButton(
        onPressed: addEvent,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}