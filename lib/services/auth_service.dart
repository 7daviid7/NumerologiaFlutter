import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream per escoltar l'estat de l'autenticació (Loguejat / No loguejat)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obtenir l'usuari actual
  User? get currentUser => _auth.currentUser;

  // Iniciar sessió amb email i contrasenya
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No s\'ha trobat cap usuari amb aquest email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('La contrasenya és incorrecta.');
      } else {
        throw Exception('Error d\'autenticació: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error desconegut: $e');
    }
  }

  // Tancar sessió
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
