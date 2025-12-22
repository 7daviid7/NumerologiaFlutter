import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatelessWidget {
  final HistoryService _historyService = HistoryService();

  FeedbackListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial i Feedback'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _historyService.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hi ha interpretacions guardades.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final docSnapshot = snapshot.data!.docs[index];
              final data = docSnapshot.data() as Map<String, dynamic>;
              final docId = docSnapshot.id;

              final name = data['fullName'] ?? 'Desconegut';
              final birthDate = data['birthDate'] ?? 'Sense data';
              final feedback =
                  data['feedback'] as String?; // 'positive' or 'negative'

              // Formatting Timestamp
              String dateStr = '';
              if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
                final date = (data['timestamp'] as Timestamp).toDate();
                dateStr = DateFormat('dd/MM HH:mm').format(date);
              }

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackDetailPage(
                          data: data,
                          docId: docId,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
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
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Data naixament: $birthDate',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Creat: $dateStr',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (feedback != null)
                          Icon(
                            feedback == 'positive'
                                ? Icons.thumb_up
                                : Icons.thumb_down,
                            color: feedback == 'positive'
                                ? Colors.green
                                : Colors.red,
                          ),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
