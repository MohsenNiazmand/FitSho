import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';

void showFailureToast(BuildContext context, Failure failure) {
  BotToast.showText(text: failureMessage(context, failure));
}

void showSuccessToast(String message) {
  BotToast.showText(text: message);
}

void showMessageToast(String message) {
  BotToast.showText(text: message);
}

void showSessionExpiredToast(BuildContext context) {
  BotToast.showText(
    text: failureMessage(context, const UnauthorizedFailure()),
  );
}
