import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/data_model.dart';
import '../services/gemini_service.dart';

import '../services/history_service.dart';

class AIInterpretationPage extends StatefulWidget {
  @override
  _AIInterpretationPageState createState() => _AIInterpretationPageState();
}

class _AIInterpretationPageState extends State<AIInterpretationPage> {
  String? _interpretation;
  bool _isLoading = false;

  Future<void> _generateInterpretation() async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    print(
        'DEBUG: API Key status: ${apiKey.isEmpty ? "BUIDA" : "TROBADA (${apiKey.substring(0, 3)}...)"}');

    if (apiKey.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Falta la API Key'),
          content: Text(
              'No s\'ha trobat la clau d\'API de Gemini. \n\nAssegura\'t de tenir el fitxer .env a l\'arrel del projecte amb la variable GEMINI_API_KEY definida.\n\nExemple:\nGEMINI_API_KEY=la_teva_clau_aqui'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('D\'acord'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _interpretation = null;
    });

    try {
      final dataModel = Provider.of<DataModel>(context, listen: false);
      final service = GeminiService(apiKey: apiKey);
      final result = await service.interpretData(dataModel.toJson());

      // Guardar a Firestore
      final historyService = HistoryService();
      await historyService.saveInterpretation(
        fullName: dataModel.name,
        birthDate: dataModel.date,
        interpretation: result,
      );

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Interpretació IA',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading)
                _buildLoadingState(theme)
              else if (_interpretation == null)
                _buildEmptyState(theme)
              else
                _buildResultState(theme),
              SizedBox(height: 24),
              if (!_isLoading)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _generateInterpretation,
                    icon: Icon(Icons.auto_awesome),
                    label: Text(_interpretation == null
                        ? 'Generar Interpretació'
                        : 'Regenerar Interpretació'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
            SizedBox(height: 30),
            Text(
              'Consultant els astres...',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'La intel·ligència artificial està analitzant els teus números.',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology_alt,
                  size: 80, color: theme.colorScheme.primary),
            ),
            SizedBox(height: 30),
            Text(
              'Descobreix el significat ocult',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Prem el botó per obtenir una lectura numerològica detallada basada en el mètode de Martine Coquatrix.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState(ThemeData theme) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.colorScheme.surface,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: MarkdownBody(
              data: _interpretation!,
              styleSheet: MarkdownStyleSheet(
                h1: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                h2: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                h3: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                p: theme.textTheme.bodyLarge
                    ?.copyWith(height: 1.6, fontSize: 16),
                listBullet: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.primary),
                blockquote: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                      left: BorderSide(
                          color: theme.colorScheme.primary, width: 4)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
