import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('interpretations');

  Future<void> saveInterpretation({
    required String fullName,
    required String birthDate,
    required String interpretation,
  }) async {
    try {
      await _historyCollection.add({
        'fullName': fullName,
        'birthDate': birthDate,
        'interpretation': interpretation,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('DEBUG: Interpretation saved to Firestore');
    } catch (e) {
      print('Error saving interpretation: $e');
      throw e;
    }
  }
}
