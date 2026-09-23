import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_profile_form.dart';

class WorkoutProfileEditScreen extends StatelessWidget {
  const WorkoutProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.workoutOnboardingTitle),
      ),
      body: const SafeArea(
        child: WorkoutProfileForm(isEditing: true),
      ),
    );
  }
}
