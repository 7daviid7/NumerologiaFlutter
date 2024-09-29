import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'results_navegation_page.dart';
import '../models/data_model.dart';
import 'package:intl/intl.dart'; // Per donar format a la data

class InputPage extends StatefulWidget {
  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Funció per obrir el selector de dates
  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    locale: const Locale('es', 'ES'), // Establecer español aquí
  );

  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked;
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    });
  }
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
              onTap: () {
                // Evitar que s'obri el teclat
                FocusScope.of(context).requestFocus(FocusNode());
                // Obrir el selector de data
                _selectDate(context);
              },
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
