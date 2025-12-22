import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'pages/input_page.dart';
import 'package:provider/provider.dart';
import 'models/data_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/shared_interpretation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numerologia',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
        const Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Check for shared link ID in URL (Public Access)
    // If an ID exists, we bypass login and go straight to the shared page.
    if (kIsWeb) {
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('id')) {
        final docId = uri.queryParameters['id'];
        if (docId != null && docId.isNotEmpty) {
          print('DEBUG: Found Public ID: $docId');
          return SharedInterpretationPage(docId: docId);
        }
      }
    }

    // 2. Check Auth State (Admin Access)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // If user is logged in -> Show App
        if (snapshot.hasData) {
          return InputPage();
        }

        // If not logged in -> Show Login
        return LoginPage();
      },
    );
  }
}
