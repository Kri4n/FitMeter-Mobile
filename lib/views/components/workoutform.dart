import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:fitmeter/model/workouts_model.dart';

class WorkoutForm extends StatefulWidget {
  final WorkoutsModel? workout;
  final Future<void> Function(String name, String duration) onSubmit;

  const WorkoutForm({super.key, this.workout, required this.onSubmit});

  @override
  State<WorkoutForm> createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout?.name ?? "");
    _durationController = TextEditingController(
      text: widget.workout?.duration ?? "00:00:00",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDuration() async {
    final pickedDuration = await showDurationPicker(
      context: context,
      initialTime: const Duration(minutes: 0),
    );
    if (pickedDuration != null) {
      final hours = pickedDuration.inHours.toString().padLeft(2, '0');
      final minutes = (pickedDuration.inMinutes % 60).toString().padLeft(
        2,
        '0',
      );
      final seconds = (pickedDuration.inSeconds % 60).toString().padLeft(
        2,
        '0',
      );
      _durationController.text = "$hours:$minutes:$seconds";
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await widget.onSubmit(
        _nameController.text.trim(),
        _durationController.text,
      );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.workout == null ? "Add Workout" : "Update Workout"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? "Title required"
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _durationController,
              readOnly: true,
              onTap: _pickDuration,
              decoration: const InputDecoration(
                labelText: "Duration",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _submit,
          child: const Text("Submit", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
