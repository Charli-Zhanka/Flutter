import 'package:flutter/material.dart';
import '../api/fake_api.dart';

class StudentList extends StatelessWidget {
  final List<Student> students;
  final bool compact;

  const StudentList(this.students, {super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          dense: compact,
          title: Text(student.name),
          subtitle: Text(student.group),
          trailing: Text(student.gpa?.toStringAsFixed(2) ?? '---'),
        );
      },
    );
  }
}