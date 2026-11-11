import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/item.dart';

class EditEventScreen extends StatefulWidget {
  final Item item;

  const EditEventScreen({
    super.key,
    required this.item,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController locationController;
  late final TextEditingController descriptionController;
  late final TextEditingController limitController;

  late EventCategory category;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.item.title,
    );
    locationController = TextEditingController(
      text: widget.item.location,
    );
    descriptionController = TextEditingController(
      text: widget.item.description ?? '',
    );
    limitController = TextEditingController(
      text: widget.item.limit.toString(),
    );

    category = widget.item.category;
    selectedDate = widget.item.when;
    selectedTime = TimeOfDay.fromDateTime(widget.item.when);
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    limitController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();

    final initialDate = selectedDate.isBefore(now)
        ? DateTime(now.year, now.month, now.day)
        : selectedDate;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 730)),
    );

    if (date != null && mounted) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time != null && mounted) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void saveChanges() {
    if (!formKey.currentState!.validate()) return;

    final newDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (!newDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choose a future date and time'),
        ),
      );
      return;
    }

    final newLimit = int.parse(limitController.text.trim());

    if (newLimit < widget.item.count) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Places cannot be fewer than current participants',
          ),
        ),
      );
      return;
    }

    final updatedItem = widget.item.copyWith(
      title: titleController.text.trim(),
      category: category,
      when: newDate,
      limit: newLimit,
      location: locationController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      clearDescription:
      descriptionController.text.trim().isEmpty,
    );

    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Event title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter an event title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<EventCategory>(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: EventCategory.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: limitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Places available',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final number = int.tryParse(value ?? '');

                if (number == null || number < 1) {
                  return 'Enter a number greater than 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                '${selectedDate.day.toString().padLeft(2, '0')}.'
                    '${selectedDate.month.toString().padLeft(2, '0')}.'
                    '${selectedDate.year}',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: pickTime,
              icon: const Icon(Icons.access_time),
              label: Text(selectedTime.format(context)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}