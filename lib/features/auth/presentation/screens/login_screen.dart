import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/constants/constants.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/auth/presentation/providers/login_provider.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_image_cover.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:fitsho/shared/presentation/widgets/legal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final mobileController = useTextEditingController();
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.isLoading;
    final theme = Theme.of(context);
    final entranceController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );

    useEffect(() {
      entranceController.forward();
      return null;
    }, [entranceController]);

    Future<void> submit() async {
      if (formKey.currentState?.validate() != true) return;

      final mobile = mobileController.text.trim();
      final failure = await ref
          .read(loginNotifierProvider.notifier)
          .requestOtp(mobile);

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      showSuccessToast(context.tr.otpSentSuccess);
      await context.push('${AppRoutes.otpVerification}?mobile=$mobile');
    }

    final brandName = Localizations.localeOf(context).languageCode == 'fa'
        ? context.tr.appNamePersian
        : context.tr.appName;

    Widget staggerEntrance({required int step, required Widget child}) {
      final start = step * 0.1;
      final end = (start + 0.55).clamp(0.0, 1.0);
      final animation = CurvedAnimation(
        parent: entranceController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          context.tr.loginTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AppImageCover(
            assetPath: AppAssets.loginBg,
            overlayOpacity: 0.65,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Gap.v24(),
                            staggerEntrance(
                              step: 0,
                              child: Center(child: _LoginBrandIcon()),
                            ),
                            Gap.v24(),
                            staggerEntrance(
                              step: 1,
                              child: Text(
                                brandName,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 12,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap.v8(),
                            staggerEntrance(
                              step: 2,
                              child: Text(
                                context.tr.loginSubtitle,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  height: 1.7,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            Gap.custom(height: 28),
                            staggerEntrance(
                              step: 3,
                              child: _LoginGlassTextField(
                                controller: mobileController,
                                labelText: context.tr.mobileNumberLabel,
                                hintText: context.tr.mobileNumberHint,
                                validator: (value) {
                                  final mobile = value?.trim() ?? '';
                                  if (!Constants.mobileNumberPattern.hasMatch(
                                    mobile,
                                  )) {
                                    return context.tr.invalidMobileNumber;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => submit(),
                              ),
                            ),
                            const Spacer(),
                            staggerEntrance(
                              step: 4,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: AppRadius.button,
                                  boxShadow: [
                                    BoxShadow(
                                      color: cPrimary.withValues(alpha: 0.38),
                                      blurRadius: 20,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: AppPrimaryButton(
                                  label: context.tr.sendOtp,
                                  icon: Icons.auto_awesome_rounded,
                                  isLoading: isLoading,
                                  onPressed: submit,
                                ),
                              ),
                            ),
                            Gap.v16(),
                            staggerEntrance(
                              step: 5,
                              child: const _LoginLegalFooter(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginLegalFooter extends StatefulWidget {
  const _LoginLegalFooter();

  @override
  State<_LoginLegalFooter> createState() => _LoginLegalFooterState();
}

class _LoginLegalFooterState extends State<_LoginLegalFooter> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _showTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _showPrivacy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _showTerms() {
    LegalBottomSheet.show(
      context,
      title: context.tr.legalTermsTitle,
      content: context.tr.legalTermsContent,
    );
  }

  void _showPrivacy() {
    LegalBottomSheet.show(
      context,
      title: context.tr.legalPrivacyTitle,
      content: context.tr.legalPrivacyContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontSize: 11,
      color: Colors.white54,
      height: 1.7,
      shadows: [
        Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(0, 1)),
      ],
    );
    final linkStyle = baseStyle.copyWith(
      color: cPrimaryLight,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: cPrimaryLight,
    );

    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: context.tr.legalAgreementPrefix),
          TextSpan(
            text: context.tr.legalTermsLink,
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          TextSpan(text: context.tr.legalAgreementMiddle),
          TextSpan(
            text: context.tr.legalPrivacyLink,
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          TextSpan(text: context.tr.legalAgreementSuffix),
        ],
      ),
    );
  }
}

class _LoginBrandIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cPrimaryLight, cPrimary, cPrimaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: cPrimary.withValues(alpha: 0.45),
            blurRadius: 28,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: const Icon(
        Icons.restaurant_menu_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class _LoginGlassTextField extends StatelessWidget {
  const _LoginGlassTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  static const _fieldRadius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    const labelColor = Colors.white;
    final hintColor = Colors.white.withValues(alpha: 0.65);
    final borderColor = Colors.white.withValues(alpha: 0.5);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: _fieldRadius,
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: _fieldRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: ColoredBox(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.4,
            ),
            cursorColor: Colors.white,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              isDense: false,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: labelText,
              hintText: hintText,
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: Colors.white.withValues(alpha: 0.92),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 52,
                minHeight: 56,
              ),
              filled: true,
              fillColor: Colors.transparent,
              labelStyle: TextStyle(
                color: labelColor.withValues(alpha: 0.92),
                fontWeight: FontWeight.w500,
                height: 1.3,
                fontSize: 13,
              ),
              hintStyle: TextStyle(color: hintColor, height: 1.4),
              errorStyle: const TextStyle(
                color: Color(0xFFFFCDD2),
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: _fieldRadius,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: _fieldRadius,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: _fieldRadius,
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.85),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: _fieldRadius,
                borderSide: const BorderSide(color: Color(0xFFEF9A9A)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: _fieldRadius,
                borderSide: const BorderSide(color: Color(0xFFFFCDD2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
