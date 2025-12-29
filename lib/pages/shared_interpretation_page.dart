import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/history_service.dart';

class SharedInterpretationPage extends StatefulWidget {
  final String docId;

  const SharedInterpretationPage({Key? key, required this.docId})
      : super(key: key);

  @override
  State<SharedInterpretationPage> createState() =>
      _SharedInterpretationPageState();
}

class _SharedInterpretationPageState extends State<SharedInterpretationPage> {
  final _feedbackController = TextEditingController();
  double _currentRating = 5.0; // Default rating initialized to 5 as requested
  bool _isSendingFeedback = false;
  bool _feedbackSent = false;
  late Future<Map<String, dynamic>?> _interpretationFuture;

  @override
  void initState() {
    super.initState();
    _interpretationFuture =
        HistoryService().getSharedInterpretation(widget.docId);
    _feedbackController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) return;

    setState(() {
      _isSendingFeedback = true;
    });

    try {
      await HistoryService().saveGuestFeedback(
          widget.docId, _feedbackController.text, _currentRating);
      if (mounted) {
        setState(() {
          _feedbackSent = true;
          _isSendingFeedback = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Moltes gràcies pel teu comentari!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSendingFeedback = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error enviant el comentari: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lectura Compartida'),
        automaticallyImplyLeading: false, // No back button for guests
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _interpretationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error carregant la lectura'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aquest enllaç ha caducat o no existeix.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text('Els enllaços només són vàlids durant 24 hores.'),
                ],
              ),
            );
          }

          final interpretation = snapshot.data!['interpretation'] as String;

          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Warning banner
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.amber.shade900),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Aquesta lectura és privada i caducarà automàticament en 24 hores.',
                          style: TextStyle(color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                MarkdownBody(
                  data: interpretation,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          height: 1.6,
                        ),
                  ),
                ),
                SizedBox(height: 48),
                Divider(),
                SizedBox(height: 24),
                Text(
                  'Què t\'ha semblat?',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                if (_feedbackSent)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Gràcies per compartir la teva experiència!',
                          style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Card(
                    elevation: 0,
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Puntuació:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Center(
                            child: RatingBar.builder(
                              initialRating: _currentRating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 40,
                              unratedColor: Colors.grey.shade300,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _currentRating = rating;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _feedbackController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText:
                                  'Explica si t\'has sentit identificat/da, o qualsevol altre comentari...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: (_isSendingFeedback ||
                                    _feedbackController.text.trim().isEmpty)
                                ? null
                                : _sendFeedback,
                            icon: _isSendingFeedback
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : Icon(Icons.send),
                            label: Text('Enviar Comentari'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 48),
                Center(
                  child: Text(
                    'Numerologia App © 2025',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
