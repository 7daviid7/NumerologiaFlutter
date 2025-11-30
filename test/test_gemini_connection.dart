import 'dart:convert';
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Si us plau, proporciona la teva API Key com a argument.');
    print('Exemple: dart tools/test_gemini_connection.dart LA_TEVA_API_KEY');
    return;
  }

  final apiKey = arguments[0];
  final url =
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey';

  print('Connectant a Gemini API per llistar models...');

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('Connexió exitosa! Models disponibles:');
      final models = json['models'] as List;
      for (var model in models) {
        print('- ${model['name']}');
      }
    } else {
      print('Error en la connexió: ${response.statusCode}');
      print('Missatge: ${response.body}');
    }
  } catch (e) {
    print('Error inesperat: $e');
  }
}
