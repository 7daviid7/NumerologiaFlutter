import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/data_model.dart';
import '../services/gemini_service.dart';

class AIInterpretationPage extends StatefulWidget {
  @override
  _AIInterpretationPageState createState() => _AIInterpretationPageState();
}

class _AIInterpretationPageState extends State<AIInterpretationPage> {
  String? _interpretation;
  bool _isLoading = false;
  // TODO: Replace with a secure way to handle API keys or input from user
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _generateInterpretation() async {
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Si us plau, introdueix una API Key vàlida.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _interpretation = null;
    });

    try {
      final dataModel = Provider.of<DataModel>(context, listen: false);
      final service = GeminiService(apiKey: _apiKeyController.text);
      final result = await service.interpretData(dataModel.toJson());

      setState(() {
        _interpretation = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interpretació IA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'Google Gemini API Key',
                border: OutlineInputBorder(),
                hintText: 'Enganxa la teva clau aquí',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateInterpretation,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.psychology),
              label: Text(_isLoading ? 'Generant...' : 'Generar Interpretació'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _interpretation == null
                  ? Center(
                      child: Text(
                        'Prem el botó per generar una interpretació basada en les teves dades numerològiques.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : SingleChildScrollView(
                      child: MarkdownBody(data: _interpretation!),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
