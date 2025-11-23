import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  GeminiService({required this.apiKey});

  Future<String> interpretData(Map<String, dynamic> data) async {
    final prompt = _buildPrompt(data);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to load interpretation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to Gemini: $e');
    }
  }

  String _buildPrompt(Map<String, dynamic> data) {
    final jsonString = JsonEncoder.withIndent('  ').convert(data);
    return '''
Actua com un expert en Numerologia, específicament en el mètode de Martine Coquatrix (Numerologia a la llum de l'arbre de la vida i les lletres hebraiques).
Interpreta les següents dades numerològiques per a una persona:

Nom: ${data['name']}
Data de Naixement: ${data['date']}

Dades Calculades:
$jsonString

Si us plau, proporciona una interpretació detallada i empàtica, explicant què signifiquen aquests números en el context del seu camí de vida, personalitat, herències i desafiaments. 
Utilitza un to professional però proper. Estructura la resposta amb encapçalaments Markdown.
Fes èmfasi en el "Camí de Vida" i els "Desafiaments".
''';
  }
}
