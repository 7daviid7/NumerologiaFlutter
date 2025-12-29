import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  GeminiService({required this.apiKey});

  // MOCK DATA FLAG
  // Automatically uses mock data in Debug/Profile, but REAL AI in Release (Production)
  static const bool useMockData = !kReleaseMode;

  Future<String> interpretData(Map<String, dynamic> data) async {
    if (useMockData) {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));
      return '''
Hola Francisco Quintanilla Garcia Mejino Fernandez,

La teva numerologia ens revela un camí marcat per una profunda recerca de llibertat i transformació, amb un potencial considerable per inspirar i construir un llegat significatiu. La teva essència et convida a l'experimentació constant, però sempre amb una base de saviesa i un fort sentit de la responsabilitat espiritual.

### Anàlisi de la Teva Personalitat (La Inclusió)

La Inclusió ens mostra com vius cada àrea de la teva existència, la qualitat inherent que imprimeixes a cada Casa de la teva vida:

*   **Identitat i Expressió Personal (Cases 1, 2, 3):**
    *   **Casa 1 (Jo, Ego): Habitant 8.** La teva afirmació personal i el teu sentit de la identitat es manifesten amb una energia de poder, de gestió de recursos i de reconeixement dels teus talents. Tens una presència forta i la capacitat d'impactar el teu entorn. Ets algú que vol fer sentir la seva veu i la seva influència.
    *   **Casa 2 (Tu, Emocions): Habitant 1.** En les teves relacions i en la gestió de les emocions, tendeixes a ser independent i a prendre la iniciativa. Busques la teva pròpia direcció emocional, el que pot portar-te a ser menys dependent però també a haver de treballar la flexibilitat i la col·laboració en els teus vincles.
    *   **Casa 3 (Ells, Comunicació): Habitant 6.** La teva expressió i la manera de comunicar-te amb els altres estan impregnades d'un sentit de la responsabilitat, l'harmonia i l'amor. Ets algú que busca connectar des del cor, amb cura i dedicació, valorant la família i la comunitat en les teves interaccions.

*   **Arrels, Treball i Món Material (Cases 4, 8):**
    *   **Casa 4 (Nosaltres, Treball): Habitant 2.** Les teves arrels, el teu sentit de seguretat i la manera de construir les teves bases laborals o personals estan influenciades per l'emoció, la necessitat de col·laboració i una gran intuïció. Necessites sentir-te connectat emocionalment amb el que fas i amb la teva llar per sentir-te estable i segur.
    *   **Casa 8 (Poder, Talents, diners): Habitant 2.** La gestió del poder, dels teus talents i dels recursos materials la vius amb una sensibilitat i una predisposició a la col·laboració. Els teus talents es despleguen millor en un entorn on hi hagi interacció i suport mutu. Atenció a no dependre excessivament de l'aprovació dels altres per manifestar el teu poder inherent.

*   **Llibertat, Amor i Espiritualitat (Cases 5, 6, 7, 9):**
    *   **Casa 5 (Llibertat, Sexualitat): Habitant 9.** La teva recerca de llibertat, la teva sexualitat i la manera d'experimentar el canvi es viuen amb un profund sentit humanitari i de saviesa. Ets algú que busca una llibertat que beneficiï a la col·lectivitat i les teves experiències personals tenen una dimensió de transcendència.
    *   **Casa 6 (Amor, Família): Habitant 4.** La manera com estimes, la teva vida familiar i les teves responsabilitats afectives estan fonamentades en l'estructura, l'ordre i una gran necessitat de construir bases sòlides. Ets molt lleial i dedicat a la teva família, buscant estabilitat i seguretat en les teves relacions.
    *   **Casa 7 (Espiritualitat, Saviesa): Habitant 1.** La teva comprensió del món, la teva espiritualitat i la recerca de coneixement es viuen amb una forta iniciativa i un esperit de lideratge. Ets un explorador individual de la veritat, no tens por d'obrir nous camins en la teva reflexió i saviesa. Podries ser un guia o mestre en àrees espirituals.
    *   **Casa 9 (Transcendència, Món): Habitant 8.** La teva obertura a l'univers, la teva connexió amb l'humanitarisme i el final d'etapes estan marcats per l'energia del poder i la transformació. Tens la capacitat de realitzar grans canvis amb un impacte ampli, d'utilitzar els teus talents per al bé comú i de tancar cicles amb força i determinació.

### Camí de Vida, Missió i Essència Interior

El teu camí vital està profundament marcat per una energia de canvi i transformació, impulsada per la teva intuïció i un gran potencial de lideratge espiritual.

*   **El teu Camí de Vida és el 5:** Aquesta és la vibració de la llibertat, el canvi i l'aventura. Has vingut a experimentar la vida en la seva plenitud, a trencar barreres, a adaptar-te i a abraçar la transformació constant. La varietat és la teva mestra i necessites la llibertat de moure't, de viatjar, de provar coses noves. Aquest camí t'impulsa a la curiositat, a la sensualitat i a una comunicació dinàmica.
*   **La teva Misió (reduïda de 2194 a 7):** Et convida a integrar la saviesa, l'estudi profund i la introspecció. Malgrat el teu esperit lliure del 5, la teva missió és trobar un significat més profund a les teves experiències, a través de la reflexió i el coneixement. És una crida a la perfecció, l'educació i a compartir la teva veritat interior.
*   **La teva Alma (81 reduït a 9):** Vibra amb la compassió i la saviesa universal. Desitges servir, connectar amb els altres a un nivell profund i contribuir al bé comú. Això reforça la dimensió humanitària del teu Camí de Vida 5 i de la teva Casa 5 amb Habitant 9.
*   **La teva Expressió (200 reduït a 2):** Mostra que el teu talent natural per manifestar-te en el món es fa a través de l'emoció, la sensibilitat i la capacitat de col·laborar. Ets un diplomàtic nat, capaç d'escoltar i d'adaptar-te per crear harmonia.
*   **La teva Personalitat (119 reduït a 11):** Un Nombre Mestre, et dota d'una intuïció molt elevada i una força moral notable. Ets un "Missatger Diví", amb la capacitat d'inspirar els altres i de ser un far de llum. Has de gestionar l'energia intensa de l'11, evitant la impaciència o la tensió nerviosa, i utilitzant la teva sensibilitat com a guia.
*   **La teva Força (29 reduït a 11):** També és un Nombre Mestre, l'11. Aquesta doble presència del Mestre 11 en la teva Personalitat i en la teva Força és molt significativa. Indica que tens un potencial immens per a la inspiració, la canalització d'idees elevades i la guia espiritual. És una energia potent que et permet liderar des de la intuïció i el cor, però que també requereix un treball constant d'equilibri i connexió amb la teva saviesa interior per no caure en l'estrès o la impaciència.

**Cicles i Arcs de Vida:**
En el teu cicle de **Producció**, el **Mestre 22** t'impulsa a materialitzar grans projectes amb una visió elevada. Tens el potencial de ser un "Constructor de Futurs", creant un llegat durador. El teu **Primer Arc de Vida**, especialment en l'Apertura (434 reduït a 11), ja va estar marcat per l'energia del Mestre 11, impulsant-te a trobar la teva veu i la teva intuïció des de ben jove.

### Desafiaments i Herències

Els reptes que se't presenten són oportunitats per polir el teu caràcter i integrar més plenament el teu potencial.

*   **Desafiament 1: el 3.** Has de superar la superficialitat o la dispersió en la comunicació. Aprèn a enfocar la teva creativitat i a expressar-te amb autenticitat i profunditat, evitant la necessitat excessiva d'aprovació social.
*   **Desafiament 2: l'1.** Treballa l'orgull i la tirania, aprenent a liderar des de l'empatia i la col·laboració, en lloc de la dominació. Desenvolupa la teva individualitat sense aïllar-te.
*   **Desafiament 3: el 2.** Has d'aprendre a gestionar la dependència i la submissió, especialment en les relacions. Desenvolupa la teva pròpia força emocional i la teva autonomia, sense perdre la teva sensibilitat ni la teva capacitat de col·laboració.

**Les teves Herències familiars** et porten un fort component de poder i responsabilitat (HHP 17 -> 8, NCS 15 -> 6, MFE 114 -> 6) i una herència Materna (MS 56 -> 11) que reafirma el potencial del Mestre 11 en el teu llinatge. Això indica una connexió profunda amb la intuïció i la missió espiritual que et ve de generacions passades, un regal i una responsabilitat.

### Equilibri Yin/Yang i Any Personal

El teu balanç energètic mostra un Yin (4.5) significativament més elevat que el teu Yang (2). Això indica una tendència natural a la receptivitat, la intuïció, la introspecció i la sensibilitat. Ets una persona que absorbeix el seu entorn i processa molta informació emocionalment. El teu repte serà equilibrar aquesta energia Yin amb una acció Yang més conscient i assertiva per evitar la passivitat o la dependència, especialment amb el Desafiament 2 (l'1).

Estàs en un **Any Personal 2**. És un any per a la col·laboració, les relacions, la diplomàcia i la sensibilitat. Presta atenció a la teva intuïció i busca la cooperació en tots els àmbits. És un bon moment per establir connexions significatives i per cuidar les teves relacions personals i professionals, integrant els teus desafiaments de l'1 i el 2.

### Conclusió

Tens un perfil numerològic potent, marcat per la llibertat del Camí de Vida 5 i la gran intuïció dels Nombres Mestres 11. Estàs cridat a ser un visionari, un comunicador inspirador i un constructor de realitats que beneficien a la col·lectivitat. Abraça la teva sensibilitat i la teva capacitat de liderar des del cor. Els teus reptes són oportunitats per a la teva evolució: aprèn a comunicar amb profunditat, a liderar des de l'autenticitat sense caure en l'orgull, i a establir relacions sanes basades en l'autonomia i la col·laboració. El teu camí és el d'un explorador amb missió, un portador de llum que, a través de les seves experiències i transformacions, té el poder de guiar i inspirar els altres. Confia en la teva intuïció, cultiva la teva saviesa interior i permet-te viure amb la llibertat i la responsabilitat que la teva ànima anhela.
''';
    }

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
    // CLONE & SANITIZE: Remove PII (Personally Identifiable Information)
    // to protect user privacy when using the API.
    final dataSanitized = Map<String, dynamic>.from(data);
    dataSanitized.remove('name');
    dataSanitized.remove('date');

    final jsonString = JsonEncoder.withIndent('  ').convert(dataSanitized);
    const contextTeoric = '''
CONTEXT TEÒRIC (Mètode Martine Coquatrix, Llibre: La numerología a la luz del árbol de vida y las letras hebraicas):
1. ELS NOMBRES (0-9):
   - 0 (Kàrmic/Desafiament): Quan apareix com a Habitant, indica un "Deute Kàrmic" o una lliçó pendent. Aquesta Casa (àrea de vida) no està integrada de forma natural i requereix un treball conscient i profund. És un repte evolutiu prioritari: has vingut a aprendre aquesta lliçó específica per desbloquejar el teu potencial.
   - 1 (Yang): Pare, inici, líder, ego, acció. Excés: Orgull, tirania.
   - 2 (Yin): Mare, emoció, col·laboració, dualitat, curiositat, intuïció. Excés: Dependència, submissió.
   - 3 (Yang): Nen, comunicació, creativitat, imatge social. Excés: Superficialitat, dispersió.
   - 4 (Yin): Arrels, treball, estructura, ordre. Excés: Rigidesa, tossuderia, obsessió pel treball i ordre.
   - 5 (Yang): Llibertat, canvi, sexualitat, aventura. Excés: Inestabilitat, vicis, obsessió pel canvi.
   - 6 (Yin): Amor, família, responsabilitat, harmonia. Excés: Sacrifici, possessió, autodestrucció.
   - 7 (Yang): Espiritualitat, estudi, reflexió, soledat. Excés: Aïllament, supèrbia, obsessió per la soledat (ERMITANY).
   - 8 (Yin/Yang): Poder, diners, talents, justícia. Excés: Materialisme, agressivitat, obsessió pel poder.
   - 9 (Yang): Humanitarisme, saviesa, estranger, compassió. Excés: Utopia, depressió, obsessió per l'humanitarisme.

2. NOMBRES MESTRES (No reduir):
   - 11: Missatger Diví. Força moral, intuïció. Risc: Nervis, impaciència.
   - 22: Constructor de Futurs. Grans projectes, geni. Risc: Desequilibri psíquic.
   - 33: Amor Incondicional. Sacrifici crístic, mestre. Risc: Abnegació total.

3. LA INCLUSIÓ (LES CASES):
   - Casa 1: Jo, Ego, Pare. Com t'afirmes al món. Lideratge, iniciativa.
   - Casa 2: Tu, Emocions, Mare. Com et relaciones i sents.
   - Casa 3: Ells, Comunicació, Germans. Com t'expresses. Divertiment i alegria.
   - Casa 4: Nosaltres (Arrels), Treball. Com construeixes la teva base. Ciments.
   - Casa 5: Llibertat, Sexualitat. Com experimentes el canvi. Excessos.
   - Casa 6: Amor, Família, parella. Com estimes i cuides. Sacrifici.
   - Casa 7: Espiritualitat, Saviesa. Com entens el món. Educació, perfecció, bellesa, estudis. En búsqueda de la perfecció i el coneixament. 
   - Casa 8: Poder, Talents, diners. Com transformes la matèria.
   - Casa 9: Transcendència, Món. Com t'obres a l'univers. Final d'etapa. 

4. ELS HABITANTS:
   - El número que ocupa una Casa és l'"Habitant". Indica la QUALITAT o la MANERA de viure aquella àrea, segons el nombre que ocupa. 
   - Ex: Habitant 7 a la Casa 1 = La persona viu la seva identitat (Casa 1) de manera reflexiva i espiritual (7).
''';

    return '''
ROL:
Ets un expert consultor en Numerologia Evolutiva, en concret la pitagòrica, especialitzat en el mètode de Martine Coquatrix (Numerologia a la llum de l'arbre de la vida). La teva missió és interpretar les dades numerològiques d'un usuari per oferir-li una guia profunda, empàtica i pràctica sobre el seu camí de vida.

$contextTeoric

DADES DE L'USUARI (JSON):
```json
$jsonString
```

DICCIONARI DE DADES (GUIA D'INTERPRETACIÓ):
- "mapVida": Conté el "Camino de Vida" (Molt important) i els cicles de vida.
- "habitants": És el mapa de la Inclusió. La clau és el número de la CASA (1-9) i el valor és l'HABITANT (el número que hi viu).
  - Exemple: "1": 7 significa "A la Casa 1 (Ego), hi viu el número 7". Interpreta això com: "La teva identitat (Casa 1) es manifesta a través de la reflexió i l'espiritualitat (7)".
- "mapPersonalidad": Nombres clau de l'ànima i la personalitat profunda.
- "mapDesafio": Reptes que la persona ha de superar.
- "mapHerencies": Càrregues o regals familiars.
- "mapPrimerArc": Primer arc de vida. Primera etapa de vida, que va sobre la primera meitat de la vida.
- "mapSegonArc": Segon arc de vida. Segona etapa de vida, que va sobre la segona meitat de la vida.

INSTRUCCIONS DE RESPOSTA:
1.  **To i Estil**: Professional, càlid, empàtic i constructiu. Parla directament a l'usuari ("Tu"). Evita ser fatalista; enfoca els reptes com a oportunitats de creixement.
2.  **Estructura**: Utilitza Markdown per organitzar la lectura.
    - **Introducció**: NO SALUDIS. Comenta directament i breument la vibració general (Camí de Vida).
    - **Anàlisi de la Personalitat (Inclusió)**: No llistis totes les cases. Agrupa-les per temes (ex: "Com et relaciones", "Món material i professional", "Món espiritual"). *Fes servir les dades de 'habitants' per explicar com viu cada àrea.*
    - **Camí de Vida i Misió**: Connecta el 'mapVida' amb el 'mapPersonalidad'.
    - **Desafiaments i Herències**: Explica què ha de treballar.
    - **Conclusió**: Un missatge final d'empoderament.
3.  **Simplificació**: Si trobes números grans al JSON que no són mestres (11, 22, 33), redueix-los (suma les xifres) per interpretar-los, però menciona el número original si aporta matís.

IMPORTANT:
- Si una Casa té el mateix número que la pròpia Casa (ex: Casa 1 amb Habitant 1), això és un "Niu" o potència pura. Destaca-ho.
- Si hi ha números mestres (11, 22, 33) als habitants o camí de vida, dona'ls molta importància.
''';
  }
}
