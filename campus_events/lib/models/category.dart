
import 'package:flutter/material.dart';

enum EventCategory {
  technology('Technology', Icons.computer),
  education('Education', Icons.school),
  networking('Networking', Icons.people),
  sport('Sport', Icons.sports),
  culture('Culture', Icons.palette);

  final String label;
  final IconData icon;

  const EventCategory(this.label, this.icon);
}
