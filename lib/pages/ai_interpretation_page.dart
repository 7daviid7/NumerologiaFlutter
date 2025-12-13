import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
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
  String? _currentDocId;
  bool? _userFeedback; // null: no feedback, true: like, false: dislike
  bool _isLoading = false;
  bool _isEditing = false;
  DateTime? _lastModified;
  late TextEditingController _editController;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

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
      final rawResult = await service.interpretData(dataModel.toJson());

      // Inject local greeting for warmth without sending PII to API
      final result = "Hola ${dataModel.name},\n\n$rawResult";

      // Guardar a Firestore
      final historyService = HistoryService();
      final docId = await historyService.saveInterpretation(
        fullName: dataModel.name,
        birthDate: dataModel.date,
        interpretation: result,
      );

      setState(() {
        _interpretation = result;
        _currentDocId = docId;
        _userFeedback = null; // Reset feedback for new interpretation
        _editController.text = result;
        Provider.of<DataModel>(context, listen: false).aiInterpretation =
            result;
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
        automaticallyImplyLeading: false,
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
              if (_interpretation != null && !_isLoading)
                _buildFeedbackSection(theme),
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
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Editant Interpretació' : 'Resultat',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (_lastModified != null && !_isEditing)
                    Text(
                      'Editat: ${_formatDate(_lastModified!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  Row(
                    children: [
                      if (_isEditing) ...[
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: _cancelEdit,
                          tooltip: 'Cancel·lar',
                        ),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: _saveEdit,
                          tooltip: 'Guardar',
                        ),
                      ] else ...[
                        IconButton(
                          icon: Icon(Icons.fullscreen,
                              color: theme.colorScheme.primary),
                          onPressed: _openFullScreen,
                          tooltip: 'Pantalla completa',
                        ),
                        IconButton(
                          icon: Icon(Icons.share,
                              color: theme.colorScheme.primary),
                          onPressed: _shareLink,
                          tooltip: 'Compartir enllaç segur',
                        ),
                        IconButton(
                          icon: Icon(Icons.copy,
                              color: theme.colorScheme.primary),
                          onPressed: _copyToClipboard,
                          tooltip: 'Copiar text',
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: theme.colorScheme.primary),
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                              _editController.text = _interpretation ?? '';
                            });
                          },
                          tooltip: 'Editar text',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: _isEditing
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _editController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Escriu aquí la interpretació...',
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16)),
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
                                      color: theme.colorScheme.primary,
                                      width: 4)),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEdit() async {
    if (_editController.text.trim().isEmpty) return;

    final newText = _editController.text;
    setState(() {
      _interpretation = newText;
      _isEditing = false;
      _lastModified = DateTime.now();
      Provider.of<DataModel>(context, listen: false).aiInterpretation = newText;
    });

    if (_currentDocId != null) {
      try {
        final historyService = HistoryService();
        await historyService.updateInterpretation(_currentDocId!, newText);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Interpretació actualitzada correctament')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error guardant els canvis: $e')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _editController.text = _interpretation ?? '';
    });
  }

  void _openFullScreen() {
    if (_interpretation == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('Interpretació Completa',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
              automaticallyImplyLeading: false,
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
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
          );
        },
      ),
    );
  }

  void _copyToClipboard() {
    if (_interpretation != null) {
      Clipboard.setData(ClipboardData(text: _interpretation!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Text copiat al porta-retalls'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _shareLink() async {
    if (_interpretation == null) return;

    // Mostrar diàleg de càrrega
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final historyService = HistoryService();
      // Guardar el link compartit
      final docId = await historyService.createSharedLink(_interpretation!);

      Navigator.pop(context); // Tancar loading

      // Construir la URL
      const baseUrl = 'https://charged-sum-419213.web.app';
      final url = '$baseUrl/?id=$docId';

      _showShareDialog(url);
    } catch (e) {
      Navigator.pop(context); // Tancar loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generant l\'enllaç: $e')),
      );
    }
  }

  void _showShareDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock_clock, color: Colors.orange),
            SizedBox(width: 10),
            Text('Enllaç Segur (24h)'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Aquest enllaç permet veure aquesta interpretació sense necessitat de l\'app. Caducarà automàticament en 24 hores.\n'),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                url,
                style: TextStyle(
                    fontFamily: 'Courier', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.copy),
            label: Text('Copiar'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Enllaç copiat!')),
              );
            },
          ),
          TextButton(
            child: Text('Tancar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('T\'ha estat útil?', style: theme.textTheme.bodyMedium),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(
              _userFeedback == true ? Icons.thumb_up : Icons.thumb_up_outlined,
              color: _userFeedback == true ? Colors.green : null,
            ),
            onPressed: () => _handleFeedback(true),
            tooltip: 'M\'agrada',
          ),
          IconButton(
            icon: Icon(
              _userFeedback == false
                  ? Icons.thumb_down
                  : Icons.thumb_down_outlined,
              color: _userFeedback == false ? Colors.red : null,
            ),
            onPressed: () => _handleFeedback(false),
            tooltip: 'No m\'agrada',
          ),
        ],
      ),
    );
  }

  Future<void> _handleFeedback(bool isPositive) async {
    if (_currentDocId == null) return;

    setState(() {
      _userFeedback = isPositive;
    });

    try {
      final historyService = HistoryService();
      await historyService.updateFeedback(_currentDocId!, isPositive);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gràcies pel teu feedback!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('Error updating feedback: $e');
      // Opcional: Revertir l'estat si falla
    }
  }
}
