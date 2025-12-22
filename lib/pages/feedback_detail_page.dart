import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart';

class FeedbackDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const FeedbackDetailPage({Key? key, required this.data, required this.docId})
      : super(key: key);

  @override
  _FeedbackDetailPageState createState() => _FeedbackDetailPageState();
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

            // Interpretation Section
            Text(
              'Interpretació',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
