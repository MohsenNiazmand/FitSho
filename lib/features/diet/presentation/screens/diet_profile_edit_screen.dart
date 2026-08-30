import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_onboarding_form.dart';

class DietProfileEditScreen extends StatelessWidget {
  const DietProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(context.tr.dietProfileEditTitle)),
        body: const DietOnboardingForm(),
      ),
    );
  }
}
