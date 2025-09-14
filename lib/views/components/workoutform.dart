import 'package:flutter/cupertino.dart';
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
      text: widget.workout?.duration ?? "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDuration() async {
    Duration initial = Duration.zero;

    final picked = await showModalBottomSheet<Duration>(
      context: context,
      builder: (context) {
        int hours = initial.inHours;
        int minutes = initial.inMinutes % 60;
        int seconds = initial.inSeconds % 60;

        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Select Duration",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  children: [
                    // Hours
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: hours,
                        ),
                        onSelectedItemChanged: (value) {
                          hours = value;
                        },
                        children: List.generate(
                          24,
                          (i) => Center(child: Text("$i h")),
                        ),
                      ),
                    ),
                    // Minutes
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: minutes,
                        ),
                        onSelectedItemChanged: (value) {
                          minutes = value;
                        },
                        children: List.generate(
                          60,
                          (i) => Center(child: Text("$i m")),
                        ),
                      ),
                    ),
                    // Seconds
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                          initialItem: seconds,
                        ),
                        onSelectedItemChanged: (value) {
                          seconds = value;
                        },
                        children: List.generate(
                          60,
                          (i) => Center(child: Text("$i s")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    Duration(hours: hours, minutes: minutes, seconds: seconds),
                  );
                },
                child: const Text("Done"),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      final hours = picked.inHours.toString().padLeft(2, '0');
      final minutes = (picked.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (picked.inSeconds % 60).toString().padLeft(2, '0');
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
              validator: (value) =>
                  (value == null || value.trim().isEmpty || value == "00:00:00")
                  ? "Duration required"
                  : null,
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
