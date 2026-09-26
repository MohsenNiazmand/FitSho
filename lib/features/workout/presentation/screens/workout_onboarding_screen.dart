import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_profile_form.dart';

class WorkoutOnboardingScreen extends StatelessWidget {
  const WorkoutOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.workoutOnboardingTitle),
        automaticallyImplyLeading: false,
      ),
      body: const SafeArea(child: WorkoutProfileForm(isEditing: false)),
    );
  }
}
