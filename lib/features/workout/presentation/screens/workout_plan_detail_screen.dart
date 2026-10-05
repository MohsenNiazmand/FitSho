import 'package:flutter/material.dart';

import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_session_section.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_plan_header.dart';

class WorkoutPlanDetailScreen extends StatelessWidget {
  const WorkoutPlanDetailScreen({required this.plan, super.key});

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      appBar: AppBar(title: Text(context.tr.workoutPlanDetailTitle)),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WorkoutPlanHeader(plan: plan, readOnly: true),
                    WorkoutSessionSection(plan: plan, readOnly: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
