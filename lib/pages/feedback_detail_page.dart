import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart';

class FeedbackDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const FeedbackDetailPage({Key? key, required this.data, required this.docId})
      : super(key: key);

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  final HistoryService _historyService = HistoryService();
  List<Map<String, dynamic>> _guestFeedback = [];
  bool _isLoadingFeedback = true;

  @override
  void initState() {
    super.initState();
    _loadGuestFeedback();
  }

  Future<void> _loadGuestFeedback() async {
    final feedback = await _historyService.getGuestFeedback(widget.docId);
    setState(() {
      _guestFeedback = feedback;
      _isLoadingFeedback = false;
    });
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
    return '';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Text copiat al porta-retalls'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareLink(String interpretation) async {
    // Mostrar diàleg de càrrega
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Guardar el link compartit
      final docId = await _historyService.createSharedLink(interpretation,
          originalDocId: widget.docId);

      if (!mounted) return;

      Navigator.pop(context); // Tancar loading

      // Construir la URL
      const baseUrl = 'https://charged-sum-419213.web.app';
      final url = '$baseUrl/?id=$docId';

      _showShareDialog(url);
    } catch (e) {
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final fullName = widget.data['fullName'] ?? 'Desconegut';
    final birthDate = widget.data['birthDate'] ?? 'Sense data';
    final interpretation = widget.data['interpretation'] ?? '';
    final userFeedback =
        widget.data['feedback']; // 'positive', 'negative', null
    final timestamp = widget.data['timestamp'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detall Interpretació'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Data naixement: $birthDate'),
                          Text(
                            'Generat: ${_formatDate(timestamp)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    _buildUserFeedbackIcon(userFeedback),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Interpretation Section header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Interpretació',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: () => _shareLink(interpretation),
                      tooltip: 'Compartir enllaç segur',
                    ),
                    IconButton(
                      icon: Icon(Icons.copy,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: () => _copyToClipboard(interpretation),
                      tooltip: 'Copiar text',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MarkdownBody(data: interpretation),
              ),
            ),

            SizedBox(height: 24),

            // Guest Feedback Section
            Text(
              'Feedback de Convidats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            SizedBox(height: 8),
            _isLoadingFeedback
                ? Center(child: CircularProgressIndicator())
                : _guestFeedback.isEmpty
                    ? Text(
                        'No hi ha comentaris de convidats.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _guestFeedback.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final feedback = _guestFeedback[index];
                          final text = feedback['text'] ?? '';
                          final date = _formatDate(feedback['timestamp']);
                          // Extract rating safely
                          double rating = 5.0;
                          if (feedback['rating'] != null) {
                            rating = (feedback['rating'] is num)
                                ? (feedback['rating'] as num).toDouble()
                                : 5.0;
                          }

                          return Card(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display Rating
                                  RatingBarIndicator(
                                    rating: rating,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(height: 8),
                                  Text(text, style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserFeedbackIcon(String? feedback) {
    if (feedback == 'positive') {
      return Icon(Icons.thumb_up, color: Colors.green, size: 32);
    } else if (feedback == 'negative') {
      return Icon(Icons.thumb_down, color: Colors.red, size: 32);
    } else {
      return SizedBox(); // No feedback
    }
  }
}
