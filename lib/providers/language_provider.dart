import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Default language
  Map<String, String> _localizedStrings = {};

  Locale get locale => _locale;
  Map<String, String> get localizedStrings => _localizedStrings;

  /// Loads language from assets/langs/{locale}.json
  Future<void> loadLanguage(Locale locale) async {
    _locale = locale;
    String langCode = "${locale.languageCode}-${locale.countryCode ?? getDefaultCountry(locale.languageCode)}";
    String filePath = "assets/langs/$langCode.json".trim();

    debugPrint("🌍 Loading language: $langCode from $filePath");

    try {
      String jsonString = await rootBundle.loadString(filePath);
      debugPrint("✅ Language file loaded successfully!");

      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));

      await _saveLanguage(locale);
    } catch (e) {
      debugPrint("❌ Error loading language file ($filePath): $e");
      await tryLoadDefault();
    }

    notifyListeners();
  }

  /// Fallback to English if loading fails
  Future<void> tryLoadDefault() async {
    if (_locale.languageCode != 'en') {
      debugPrint("🔄 Falling back to English (US)...");
      await loadLanguage(const Locale('en', 'US'));
    }
  }

  /// Saves selected language to SharedPreferences
  Future<void> _saveLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_locale', locale.languageCode);
    await prefs.setString('selected_country_code', locale.countryCode ?? getDefaultCountry(locale.languageCode));
    debugPrint("📦 Saved locale: ${locale.languageCode}-${locale.countryCode}");
  }

  /// Loads saved language preference
  Future<void> loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedLanguageCode = prefs.getString('selected_locale') ?? 'en';
    String savedCountryCode = prefs.getString('selected_country_code') ?? getDefaultCountry(savedLanguageCode);

    debugPrint("🔍 Retrieving saved locale: $savedLanguageCode-$savedCountryCode");

    Locale savedLocale = Locale(savedLanguageCode, savedCountryCode);
    await loadLanguage(savedLocale);
  }

  /// Changes app language
  void changeLanguage(Locale locale) {
    if (locale != _locale) {
      debugPrint("🔄 Changing language to: ${locale.languageCode}-${locale.countryCode}");
      loadLanguage(locale);
    }
  }

  /// Returns translated string from key
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Returns default country code based on language
  String getDefaultCountry(String languageCode) {
    Map<String, String> defaultCountries = {
      'en': 'US', // English (default)
      'hi': 'IN', // Hindi
      'fr': 'FR', // French
      'es': 'ES', // Spanish
      'de': 'DE', // German
    };
    return defaultCountries[languageCode] ?? 'US';
  }
}
