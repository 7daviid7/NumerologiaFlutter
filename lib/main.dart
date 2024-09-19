import 'package:flutter/material.dart';
import 'pages/input_page.dart';
import 'package:provider/provider.dart';
import 'models/data_model.dart'; 



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
      
    );
  }
}
