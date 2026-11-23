import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/services/storage_service.dart';
import 'package:nishit_vadgama/generated/l10n.dart';

class LocalizationService {
  LocalizationService._();

  static const String _keyLanguage = 'selected_language_code';

  static const Locale english = Locale('en');
  static const Locale malayalam = Locale('ml');

  static const List<Locale> supportedLocales = [english, malayalam];
  static final Rx<Locale> currentLocaleRx = english.obs;

  static Locale get currentLocale => currentLocaleRx.value;
  static String get currentLanguageCode => currentLocale.languageCode;

  static bool get isEnglish => currentLocale.languageCode == 'en';
  static bool get isMalayalam => currentLocale.languageCode == 'ml';

  static Future<void> init() async {
    final savedCode = await StorageService.read(_keyLanguage);
    if (savedCode != null && savedCode.isNotEmpty) {
      if (savedCode == 'ml') {
        currentLocaleRx.value = malayalam;
      } else {
        currentLocaleRx.value = english;
      }
    } else {
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale?.languageCode == 'ml') {
        currentLocaleRx.value = malayalam;
      } else {
        currentLocaleRx.value = english;
      }
    }
  }

  static Future<void> changeLocale(Locale newLocale) async {
    if (currentLocale.languageCode == newLocale.languageCode) return;
    currentLocaleRx.value = newLocale;
    await StorageService.write(_keyLanguage, newLocale.languageCode);
    await Get.updateLocale(newLocale);
    await S.load(newLocale);
  }

  static Future<void> setEnglish() => changeLocale(english);

  static Future<void> setMalayalam() => changeLocale(malayalam);
}
