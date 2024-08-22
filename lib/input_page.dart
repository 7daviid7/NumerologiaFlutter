import 'package:flutter/material.dart';
import 'results_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Numerologia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Introdueix el teu nom:'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Nom'),
            ),
            SizedBox(height: 20),
            Text('Introdueix la teva data de naixement:'),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(hintText: 'Data de naixement (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final date = _dateController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(name: name, date: date),
                  ),
                );
              },
              child: Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }
}
