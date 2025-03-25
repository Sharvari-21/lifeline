import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'package:sharvari/providers/language_provider.dart'; // Language provider
import 'package:sharvari/screens/home_screen.dart';
import 'package:sharvari/screens/login_screen.dart';
import 'package:sharvari/screens/signup_screen.dart';
import 'package:sharvari/screens/reset_password.dart';
import 'package:sharvari/screens/profile_screen.dart';
import 'package:sharvari/screens/nearby_hospitals_location.dart';
import 'package:sharvari/screens/emergency_screen.dart';
import 'package:sharvari/screens/general_physician_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Locale savedLocale = await _getSavedLocale();
  debugPrint("🌍 Loaded saved locale: ${savedLocale.languageCode}-${savedLocale.countryCode}");

  runApp(MyApp(savedLocale: savedLocale));
}

/// Retrieves the saved locale or defaults to English (US)
Future<Locale> _getSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString('selected_locale') ?? 'en';
  String countryCode = prefs.getString('selected_country_code') ?? 'US';

  debugPrint("📦 Retrieved locale from prefs: $languageCode-$countryCode");
  return Locale(languageCode, countryCode);
}

class MyApp extends StatelessWidget {
  final Locale savedLocale;
  const MyApp({super.key, required this.savedLocale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        var provider = LanguageProvider();
        provider.loadLanguage(savedLocale);
        return provider;
      },
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lifeline',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('hi', 'IN'),
              Locale('fr', 'FR'),
              Locale('es', 'ES'),
              Locale('de', 'DE'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/login',
            routes: {
              '/': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/reset_password': (context) => const ResetPassword(),
              '/profile': (context) => const ProfileScreen(),
              '/nearbyhospitals': (context) => NearbyHospitalsScreen(),
              '/emergencyscreen': (context) => EmergencyScreen(),
              '/generalphysicianscreen': (context) => GeneralPhysicianScreen(),
            },
          );
        },
      ),
    );
  }
}
