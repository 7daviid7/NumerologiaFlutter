import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// Conditional import to avoid errors when compiling for non-web platforms
import 'dart:js' as js;

class IosInstallPrompt extends StatefulWidget {
  const IosInstallPrompt({super.key});

  @override
  State<IosInstallPrompt> createState() => _IosInstallPromptState();
}

class _IosInstallPromptState extends State<IosInstallPrompt> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _checkVisibility();
  }

  void _checkVisibility() {
    try {
      // 1. Check if running on Web
      if (!kIsWeb) return;

      // 2. Check if platform is iOS (iPhone or iPad)
      if (defaultTargetPlatform != TargetPlatform.iOS) {
        // Basic check failed, let's try a stricter JS check for iOS/iPadOS
        final userAgent =
            js.context['navigator']['userAgent'].toString().toLowerCase();
        final isIos = userAgent.contains('iphone') ||
            userAgent.contains('ipad') ||
            userAgent.contains('ipod');

        // Special check for iPad on iPadOS 13+ (reports as Mac but has touch points)
        final isMac = userAgent.contains('macintosh');
        // Safer check for maxTouchPoints to avoid crashes if undefined or different type
        int touchPoints = 0;
        try {
          final mp = js.context['navigator']['maxTouchPoints'];
          if (mp != null) {
            if (mp is int)
              touchPoints = mp;
            else if (mp is num) touchPoints = mp.toInt();
          }
        } catch (_) {}

        final isIpadOs = isMac && touchPoints > 1;

        if (!isIos && !isIpadOs) return;
      }

      // 3. Check if ALREADY in Standalone mode (Installed)
      // window.matchMedia('(display-mode: standalone)').matches
      bool isStandalone = false;
      try {
        final mediaQuery =
            js.context.callMethod('matchMedia', ['(display-mode: standalone)']);
        if (mediaQuery != null && mediaQuery['matches'] == true) {
          isStandalone = true;
        }
      } catch (_) {}

      if (isStandalone) return;

      // If passed all checks, show the prompt
      setState(() {
        _isVisible = true;
      });
    } catch (e) {
      // If ANY JS interop fails (e.g. navigator null, obscure browser),
      // fail silently and do NOT show the prompt, but DO NOT CRASH the app.
      print('Error checking iOS PWA status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
      child: Material(
        color: Colors.transparent,
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.download, color: Colors.blueAccent),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instal·la NUMEN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Afegeix l\'app al teu inici',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => setState(() => _isVisible = false),
                  )
                ],
              ),
              Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStep(Icons.ios_share, '1. Prem Compartir'),
                  Icon(Icons.arrow_forward,
                      size: 16, color: Colors.grey.shade300),
                  _buildStep(Icons.add_box_outlined, '2. Afegeix a l\'inici'),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
