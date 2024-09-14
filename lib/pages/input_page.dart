import 'package:flutter/material.dart';
import 'results_navegation_page.dart';
import '../models/data_model.dart';
import 'package:provider/provider.dart'; 
class InputPage extends StatefulWidget {
  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

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
                //import del model provider
                final dataModel = Provider.of<DataModel>(context, listen: false);
                dataModel.setData(name, date);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsNavigatorPage()
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
