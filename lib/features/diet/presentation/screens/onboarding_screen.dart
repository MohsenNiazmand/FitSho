import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_onboarding_form.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.dietOnboardingTitle),
        automaticallyImplyLeading: false, // Prevent going back if mandatory
      ),
      body: const SafeArea(
        child: DietOnboardingForm(),
      ),
    );
  }
}
