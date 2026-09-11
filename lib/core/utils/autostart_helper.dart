import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoStartHelper {
  AutoStartHelper._();

  static const MethodChannel _channel =
      MethodChannel('com.mnz.fitsho/autostart');
  static const String _prefKeyAutoStartPromptShown =
      'autostart_prompt_shown_v1';

  /// Checks if the device runs on a restricted OEM Android OS
  /// (Xiaomi, Redmi, Poco, Huawei, Honor, Oppo, Vivo, Realme, OnePlus, etc.).
  static Future<bool> isRestrictedOem() async {
    if (!Platform.isAndroid) return false;
    try {
      final supported =
          await _channel.invokeMethod<bool>('isAutoStartSupported');
      return supported ?? false;
    } on Object catch (e) {
      debugPrint('AutoStartHelper: isRestrictedOem failed: $e');
      return false;
    }
  }

  /// Retrieves the device manufacturer name from native Android Build.
  static Future<String> getDeviceManufacturer() async {
    if (!Platform.isAndroid) return '';
    try {
      final manufacturer =
          await _channel.invokeMethod<String>('getDeviceManufacturer');
      return manufacturer ?? '';
    } on Object catch (e) {
      debugPrint('AutoStartHelper: getDeviceManufacturer failed: $e');
      return '';
    }
  }

  /// Checks whether the user has already seen the AutoStart prompt dialog.
  static Future<bool> hasPromptBeenShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_prefKeyAutoStartPromptShown) ?? false;
    } on Object catch (e) {
      debugPrint('AutoStartHelper: hasPromptBeenShown failed: $e');
      return false;
    }
  }

  /// Marks the prompt as shown in SharedPreferences so the user isn't
  /// prompted again.
  static Future<void> markPromptAsShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyAutoStartPromptShown, true);
    } on Object catch (e) {
      debugPrint('AutoStartHelper: markPromptAsShown failed: $e');
    }
  }

  /// Programmatically launches the OEM's native AutoStart / Background permission settings.
  static Future<bool> openAutoStartSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('openAutoStart');
      return result ?? false;
    } on Object catch (e) {
      debugPrint('AutoStartHelper: openAutoStartSettings failed: $e');
      return false;
    }
  }
}
