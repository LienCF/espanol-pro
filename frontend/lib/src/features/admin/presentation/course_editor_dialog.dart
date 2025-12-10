import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../course_learning/domain/course.dart';
import '../data/admin_repository.dart';

class CourseEditorDialog extends ConsumerStatefulWidget {
  final Course? course; // If null, create mode

  const CourseEditorDialog({super.key, this.course});

  @override
  ConsumerState<CourseEditorDialog> createState() => _CourseEditorDialogState();
}

class _CourseEditorDialogState extends ConsumerState<CourseEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _slugController;
  String _level = 'A1';
  String _trackType = 'GENERAL';

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.course?.id ?? '');
    _titleController = TextEditingController(
      text: widget.course?.title ?? '',
    ); // TODO: Handle localized JSON editing
    _descController = TextEditingController(
      text: widget.course?.description ?? '',
    );
    _slugController = TextEditingController(text: widget.course?.slug ?? '');
    _level = widget.course?.level ?? 'A1';
    _trackType = widget.course?.trackType ?? 'GENERAL';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.course == null ? 'Create Course' : 'Edit Course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
                enabled: widget.course == null, // ID immutable after create
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _slugController,
                decoration: const InputDecoration(labelText: 'Slug'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (JSON for now)',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _level,
                items: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => _level = v!),
                decoration: const InputDecoration(labelText: 'Level'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _trackType,
                items: ['GENERAL', 'SPECIALIZED']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _trackType = v!),
                decoration: const InputDecoration(labelText: 'Track Type'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: _idController.text,
        slug: _slugController.text,
        title: _titleController.text,
        description: _descController.text,
        level: _level,
        trackType: _trackType,
      );

      try {
        if (widget.course == null) {
          await ref.read(adminRepositoryProvider).createCourse(course);
        } else {
          await ref.read(adminRepositoryProvider).updateCourse(course);
        }
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
}
