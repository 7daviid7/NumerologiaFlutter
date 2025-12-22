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

  Future<void> updateInterpretation(String docId, String newText) async {
    try {
      await _historyCollection.doc(docId).update({
        'interpretation': newText,
        'lastModified': FieldValue.serverTimestamp(),
      });
      print('DEBUG: Interpretation updated for doc $docId');
    } catch (e) {
      print('Error updating interpretation: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getHistoryStream() {
    return _historyCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // --- Mètodes per a Links Compartits ---

  final CollectionReference _sharedCollection =
      FirebaseFirestore.instance.collection('shared_interpretations');

  Future<String> createSharedLink(String interpretation,
      {String? originalDocId}) async {
    try {
      final now = DateTime.now();
      // Caduca en 24 hores
      final expiresAt = now.add(Duration(hours: 24));

      final docRef = await _sharedCollection.add({
        'interpretation': interpretation,
        'originalDocId': originalDocId, // Link to the original interpretation
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(expiresAt),
      });

      print('DEBUG: Link compartit creat amb ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating shared link: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSharedInterpretation(String docId) async {
    try {
      final doc = await _sharedCollection.doc(docId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;

      // Comprovar caducitat
      if (data['expiresAt'] != null) {
        final expiresAt = (data['expiresAt'] as Timestamp).toDate();
        if (DateTime.now().isAfter(expiresAt)) {
          print('DEBUG: Link caducat');
          return null; // O podriem retornar un status 'expired'
        }
      }

      return data;
    } catch (e) {
      print('Error fetching shared link: $e');
      return null;
    }
  }

  Future<void> saveGuestFeedback(String docId, String feedback) async {
    try {
      await _sharedCollection.doc(docId).update({
        'guestFeedback': FieldValue.arrayUnion([
          {
            'text': feedback,
            'timestamp': Timestamp.now(),
          }
        ]),
      });
      print('DEBUG: Guest feedback saved for $docId');
    } catch (e) {
      print('Error saving guest feedback: $e');
      rethrow;
    }
  }

  /// Retrieves guest feedback associated with an original interpretation ID.
  /// Returns a list of strings (the feedback texts).
  Future<List<Map<String, dynamic>>> getGuestFeedback(
      String originalDocId) async {
    try {
      final querySnapshot = await _sharedCollection
          .where('originalDocId', isEqualTo: originalDocId)
          .get();

      List<Map<String, dynamic>> allFeedback = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('guestFeedback') &&
            data['guestFeedback'] is List) {
          final feedbackList = data['guestFeedback'] as List;
          for (var item in feedbackList) {
            if (item is Map<String, dynamic>) {
              allFeedback.add(item);
            }
          }
        }
      }
      return allFeedback;
    } catch (e) {
      print('Error getting guest feedback: $e');
      return [];
    }
  }
}
