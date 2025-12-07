import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'pages/input_page.dart';
import 'package:provider/provider.dart';
import 'models/data_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/shared_interpretation_page.dart';

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
    // Check for query parameters if running on Web
    String? initialDocId;
    if (kIsWeb) {
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('id')) {
        initialDocId = uri.queryParameters['id'];
        print('DEBUG: Found ID in URL: $initialDocId');
      }
    }

    return MaterialApp(
      title: 'Numerologia',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      // If we have an ID, show the shared page, otherwise normal InputPage
      home: initialDocId != null
          ? SharedInterpretationPage(docId: initialDocId)
          : InputPage(),
      debugShowCheckedModeBanner: false,

      // Configuració de localitzacions
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Suport per espanyol
        const Locale('en', 'US'), // Suport per anglès (opcional)
      ],
      locale: const Locale(
          'es', 'ES'), // Estableix l'espanyol com a idioma per defecte
    );
  }
}
