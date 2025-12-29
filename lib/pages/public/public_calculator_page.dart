import 'package:flutter/material.dart';
import 'package:numerologia/services/numerology_calculation_service.dart';
import '../../data/numerology_content.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicCalculatorPage extends StatefulWidget {
  const PublicCalculatorPage({super.key});

  @override
  State<PublicCalculatorPage> createState() => _PublicCalculatorPageState();
}

class _PublicCalculatorPageState extends State<PublicCalculatorPage> {
  final _dateController = TextEditingController();
  int? _lifePathNumber;
  NumerologyItem? _resultItem;

  void _calculate() {
    if (_dateController.text.isEmpty) return;

    // 1. Calculate Values using the service
    // returns a Map<String, int>
    final results = calculateDataValues(_dateController.text);

    // 2. Get Life Path Number (Camino de Vida)
    final lifePath = results['Camino de Vida'];

    if (lifePath != null) {
      setState(() {
        _lifePathNumber = lifePath;
        // 3. Find the rich content
        try {
          // Check Master Numbers first
          _resultItem = NumerologyContent.masterNumbers.firstWhere(
            (item) => item.id == lifePath.toString(),
            orElse: () => NumerologyContent.basicNumbers.firstWhere(
              (item) => item.id == lifePath.toString(),
            ),
          );
        } catch (e) {
          // Fallback if not found (should not happen for standard 1-9, 11, 22, 33)
          _resultItem = null;
        }
      });
    }
  }

  Future<void> _launchWhatsApp() async {
    // Replace with the actual professional number
    final Uri url = Uri.parse(
        'https://wa.me/34650121367?text=Hola,%20he%20calculat%20el%20meu%20Camí%20de%20Vida%20($_lifePathNumber)%20i%20vull%20saber-ne%20més.');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text('Calculadora Gratuïta'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- INSTRUCTIONS ---
                Text(
                  'Descobreix el teu Camí de Vida',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                ),
                SizedBox(height: 16),
                Text(
                  'Introdueix la teva data de naixement per revelar el número que defineix la teva missió vital.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 40),

                // --- INPUT FORM ---
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Data de Naixement (DD/MM/AAAA)',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        onChanged: (val) {
                          // Optional: Auto-format or validate
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _calculate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'CALCULAR ARA',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // --- RESULT SECTION ---
                if (_lifePathNumber != null && _resultItem != null) ...[
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _resultItem!.color.withOpacity(0.1),
                          Colors.white
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _resultItem!.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'El teu número és:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _resultItem!.color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _resultItem!.color.withOpacity(0.4),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            '$_lifePathNumber',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          _resultItem!.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _resultItem!.shortDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: _resultItem!.color,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 24),
                        Divider(),
                        SizedBox(height: 24),
                        Text(
                          _resultItem!.fullDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                        ),

                        SizedBox(height: 48),

                        // --- TEASER / CTA ---
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.lock_outline,
                                  color: Colors.amber, size: 32),
                              SizedBox(height: 16),
                              Text(
                                'Això és només el 5% de la teva Carta.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Et falta descobrir els teus Cicles de Vida, Desafiaments, la teva Inclusió i els teus Arcs de Realització.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _launchWhatsApp,
                                icon: Icon(Icons
                                    .whatshot), // WhatsApp-like icon (or generic)
                                label: Text('RESERVAR SESSIÓ PROFESSIONAL'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green, // WhatsApp color
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
