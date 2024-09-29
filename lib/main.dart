import 'package:flutter/material.dart';
import 'pages/input_page.dart';
import 'package:provider/provider.dart';
import 'models/data_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Importa el paquete necesario para localizaciones

void main() {
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
      home: InputPage(), // Canvia el widget d'inici
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
      locale: const Locale('es', 'ES'), // Estableix l'espanyol com a idioma per defecte
    );
  }
}
