import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/core/notifications/push_notification_service.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/constants/constants.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/auth/presentation/providers/login_provider.dart';
import 'package:fitsho/features/auth/presentation/providers/verify_otp_provider.dart';
import 'package:fitsho/features/auth/presentation/widgets/otp_background_pattern.dart';
import 'package:fitsho/features/auth/presentation/widgets/otp_pin_field.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class OtpVerificationScreen extends HookConsumerWidget {
  const OtpVerificationScreen({required this.mobileNumber, super.key});

  final String mobileNumber;

  static String _formatCountdown(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final formatted = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return PersianDigits.toPersian(formatted);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpPinKey = useMemoized(GlobalKey<OtpPinFieldState>.new);
    final verifyState = ref.watch(verifyOtpNotifierProvider);
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = verifyState.isLoading || loginState.isLoading;
    final resendSecondsRemaining = useState(Constants.otpResendCooldownSeconds);
    final resendCooldownGeneration = useState(0);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canResend = resendSecondsRemaining.value <= 0 && !isLoading;

    useEffect(() {
      if (!Constants.mobileNumberPattern.hasMatch(mobileNumber)) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go(AppRoutes.login);
        });
      }
      return null;
    }, [mobileNumber]);

    useEffect(() {
      if (resendSecondsRemaining.value <= 0) {
        return null;
      }

      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resendSecondsRemaining.value <= 1) {
          resendSecondsRemaining.value = 0;
          timer.cancel();
        } else {
          resendSecondsRemaining.value = resendSecondsRemaining.value - 1;
        }
      });

      return timer.cancel;
    }, [resendCooldownGeneration.value]);

    void restartResendCooldown() {
      resendSecondsRemaining.value = Constants.otpResendCooldownSeconds;
      resendCooldownGeneration.value++;
    }

    Future<void> verify([String? otpCode]) async {
      final otp = (otpCode ?? otpPinKey.currentState?.otpText ?? '').trim();
      if (otp.length != Constants.otpLength) {
        showFailureToast(context, ValidationFailure(context.tr.otpInvalid));
        return;
      }

      final result = await ref
          .read(verifyOtpNotifierProvider.notifier)
          .verifyOtp(mobileNumber: mobileNumber, otpCode: otp);

      if (!context.mounted) return;

      if (result.failure != null) {
        showFailureToast(context, result.failure!);
        return;
      }

      await ref.read(pushNotificationServiceProvider).registerTokenIfPossible();

      if (!context.mounted) return;

      context.go(AppRoutes.home);
    }

    Future<void> resend() async {
      if (!canResend) return;

      final failure = await ref
          .read(loginNotifierProvider.notifier)
          .requestOtp(mobileNumber);

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      otpPinKey.currentState?.restartSmsListener();
      restartResendCooldown();
      showSuccessToast(context.tr.otpSentSuccess);
    }

    return PopScope(
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: OtpBackgroundPattern()),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () => context.go(AppRoutes.login),
                                // RTL layout: back points right.
                                icon: const Icon(Icons.arrow_forward_rounded),
                              ),
                            ),
                            Gap.v8(),
                            Center(
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: cPrimary.withValues(alpha: 0.15),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.mark_email_read_outlined,
                                  size: 34,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            Gap.v24(),
                            Text(
                              context.tr.otpEnterInstruction,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                            Gap.v12(),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                Text(
                                  PersianDigits.toPersian(mobileNumber),
                                  textDirection: TextDirection.ltr,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.go(AppRoutes.login),
                                  style: TextButton.styleFrom(
                                    foregroundColor: cTextHint,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    context.tr.editMobileNumber,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cTextHint,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap.v32(),
                            OtpPinField(key: otpPinKey, onCompleted: verify),
                            Gap.v24(),
                            if (resendSecondsRemaining.value > 0)
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${context.tr.resendOtpCountdownPrefix} ',
                                    ),
                                    TextSpan(
                                      text: _formatCountdown(
                                        resendSecondsRemaining.value,
                                      ),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.primary,
                                          ),
                                    ),
                                    if (context
                                        .tr
                                        .resendOtpCountdownSuffix
                                        .isNotEmpty)
                                      TextSpan(
                                        text:
                                            ' ${context.tr.resendOtpCountdownSuffix}',
                                      ),
                                  ],
                                ),
                              )
                            else
                              TextButton(
                                onPressed: canResend ? resend : null,
                                child: Text(
                                  context.tr.resendOtp,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: AppRadius.button,
                                boxShadow: [
                                  BoxShadow(
                                    color: cPrimary.withValues(alpha: 0.2),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: AppPrimaryButton(
                                label: context.tr.verifyOtp,
                                isLoading: isLoading,
                                onPressed: verify,
                              ),
                            ),
                            Gap.v16(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
