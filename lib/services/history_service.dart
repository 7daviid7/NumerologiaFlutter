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

  Stream<QuerySnapshot> getHistoryStream({int limit = 20}) {
    return _historyCollection
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
  }

  // --- Mètodes de Cerca (Autocomplete) ---

  Future<List<String>> searchNames(String query) async {
    if (query.isEmpty) return [];

    // "Comença per..." query
    // \uf8ff és un caràcter Unicode molt alt, va bé per fer rangs de strings.
    final endQuery = '$query\uf8ff';

    try {
      final snapshot = await _historyCollection
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThan: endQuery)
          .limit(10) // Suggereix max 10 noms
          .get();

      final names = snapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['fullName'] as String)
          .toSet() // Elimina duplicats (mateix client 2 cops)
          .toList();

      return names;
    } catch (e) {
      print('Error searching names: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> getHistoryByName(String fullName) {
    return _historyCollection
        .where('fullName', isEqualTo: fullName)
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

  Future<void> saveGuestFeedback(
      String docId, String feedback, double rating) async {
    try {
      await _sharedCollection.doc(docId).update({
        'guestFeedback': FieldValue.arrayUnion([
          {
            'text': feedback,
            'rating': rating,
            'timestamp': Timestamp.now(),
          }
        ]),
      });
      print('DEBUG: Guest feedback saved for $docId with rating $rating');
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

  Future<List<Map<String, dynamic>>> getPublicTestimonials(
      {int limit = 5}) async {
    try {
      // 1. Fetch shared interpretations (most recent first)
      // Note: We cannot easily filter by "guestFeedback is not null" inside an array in a simple query,
      // so we fetch a batch of recent shared links and filter them in Dart.
      // Assuming the volume of shared links isn't massive yet, fetching 50 is safe.
      final snapshot = await _sharedCollection
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      List<Map<String, dynamic>> results = [];

      for (var doc in snapshot.docs) {
        if (results.length >= limit) break;

        final data = doc.data() as Map<String, dynamic>;

        // Check if guestFeedback exists and has items
        if (data['guestFeedback'] != null &&
            data['guestFeedback'] is List &&
            (data['guestFeedback'] as List).isNotEmpty) {
          final feedbacks = data['guestFeedback'] as List;
          // Get the latest feedback (last in array usually, or check timestamps)
          // For simplicity, we take the last one added.
          final lastFeedback = feedbacks.last;
          String feedbackText = '';
          if (lastFeedback is Map && lastFeedback['text'] != null) {
            feedbackText = lastFeedback['text'];
          }

          if (feedbackText.isEmpty) continue;

          // 2. Fetch original name from 'interpretations' collection
          String fullName = 'Anònim';
          final originalDocId = data['originalDocId'];

          if (originalDocId != null) {
            try {
              final originalDoc =
                  await _historyCollection.doc(originalDocId).get();
              if (originalDoc.exists) {
                final originalData = originalDoc.data() as Map<String, dynamic>;
                fullName = originalData['fullName'] ?? 'Anònim';
              }
            } catch (e) {
              print('Error fetching original doc name: $e');
            }
          }

          double rating = 5.0;
          if (lastFeedback is Map && lastFeedback['rating'] != null) {
            rating = (lastFeedback['rating'] is num)
                ? (lastFeedback['rating'] as num).toDouble()
                : 5.0;
          }

          results.add({
            'fullName': fullName,
            'interpretation':
                feedbackText, // Mapping feedback text to 'interpretation' key for UI compatibility
            'rating': rating,
            'timestamp':
                data['createdAt'], // Using link creation time or feedback time
          });
        }
      }

      return results;
    } catch (e) {
      print('Error fetching public testimonials: $e');
      return [];
    }
  }
}
