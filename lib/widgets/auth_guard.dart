import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/input_page.dart';
import '../pages/public/landing_page.dart';
import '../pages/shared_interpretation_page.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Check for shared link ID in URL (Public Access)
    // If an ID exists, we bypass login and go straight to the shared page.
    if (kIsWeb) {
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('id')) {
        final docId = uri.queryParameters['id'];
        if (docId != null && docId.isNotEmpty) {
          print('DEBUG: Found Public ID: $docId');
          return SharedInterpretationPage(docId: docId);
        }
      }
    }

    // 2. Check Auth State (Admin Access)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // If user is logged in -> Show App
        if (snapshot.hasData) {
          return InputPage();
        }

        // If not logged in -> Show Landing Page (Public)
        return const LandingPage();
      },
    );
  }
}
