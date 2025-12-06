import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('interpretations');

  Future<String> saveInterpretation({
    required String fullName,
    required String birthDate,
    required String interpretation,
  }) async {
    try {
      final docRef = await _historyCollection.add({
        'fullName': fullName,
        'birthDate': birthDate,
        'interpretation': interpretation,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('DEBUG: Interpretation saved to Firestore with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error saving interpretation: $e');
      rethrow;
    }
  }

  Future<void> updateFeedback(String docId, bool isPositive) async {
    try {
      await _historyCollection.doc(docId).update({
        'feedback': isPositive ? 'positive' : 'negative',
      });
      print('DEBUG: Feedback updated for doc $docId');
    } catch (e) {
      print('Error updating feedback: $e');
      rethrow;
    }
  }
}
