import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pinput.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/constants/constants.dart';
import 'package:fitsho/core/utils/persian_digits.dart';

/// Extracts a 6-digit OTP from SMS text (Latin or Persian digits).
String extractOtpFromSms(String? smsText) {
  if (smsText == null || smsText.isEmpty) {
    return '';
  }

  final latinMatch =
      RegExp('\\d{${Constants.otpLength}}').firstMatch(smsText);
  if (latinMatch != null) {
    return latinMatch.group(0)!;
  }

  final persianMatch =
      RegExp('[۰-۹]{${Constants.otpLength}}').firstMatch(smsText);
  if (persianMatch != null) {
    return PersianDigits.toLatin(persianMatch.group(0)!);
  }

  return '';
}

/// OTP pin field with Android SMS User Consent autofill via [otp_autofill].
class OtpPinField extends StatefulWidget {
  const OtpPinField({
    required this.onCompleted,
    super.key,
  });

  final ValueChanged<String> onCompleted;

  @override
  State<OtpPinField> createState() => OtpPinFieldState();
}

class OtpPinFieldState extends State<OtpPinField> {
  late final OTPInteractor _otpInteractor;
  late final OTPTextEditController _otpController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _otpInteractor = OTPInteractor();
    _focusNode = FocusNode();
    unawaited(_otpInteractor.getAppSignature());

    _otpController = OTPTextEditController(
      codeLength: Constants.otpLength,
      otpInteractor: _otpInteractor,
      onCodeReceive: widget.onCompleted,
      onTimeOutException: _startListenUserConsent,
    );

    _startListenUserConsent();
  }

  void _startListenUserConsent() {
    unawaited(
      _otpController.startListenUserConsent(extractOtpFromSms),
    );
  }

  /// Restarts SMS listener after resend.
  void restartSmsListener() {
    _otpController.clear();
    _startListenUserConsent();
  }

  void clear() {
    _otpController.clear();
  }

  String get otpText => _otpController.text;

  @override
  void dispose() {
    _otpController.stopListen();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const pinBorderRadius = BorderRadius.all(Radius.circular(14));

    BoxDecoration pinDecoration({
      required Color borderColor,
      double borderWidth = 1,
    }) {
      return BoxDecoration(
        color: colorScheme.surface,
        borderRadius: pinBorderRadius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      decoration: pinDecoration(borderColor: colorScheme.outline),
    );

    return AutofillGroup(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          controller: _otpController,
          focusNode: _focusNode,
          length: Constants.otpLength,
          autofocus: true,
          autofillHints: const [AutofillHints.oneTimeCode],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: pinDecoration(
              borderColor: colorScheme.primary,
              borderWidth: 2.5,
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: pinDecoration(
              borderColor: cPrimary.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}
