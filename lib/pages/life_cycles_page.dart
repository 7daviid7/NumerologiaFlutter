
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart'; 

class LifeCyclesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cicles de Vida')),
      body: Center(
        child: Text('Cicles de Vida - Encara en desenvolupament'),
      ),
    );
  }
}
