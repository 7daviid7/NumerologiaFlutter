import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChartExplanationPage extends StatelessWidget {
  const ChartExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La Carta Numerològica'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HERO SECTION ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              color: Color(0xFFFAFAFA),
              child: Column(
                children: [
                  Text(
                    'EL MAPA DE L\'ÀNIMA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 700),
                    child: Text(
                      'La Carta Numerològica no és una bola de cristall. És un mapa de navegació que revela el teu potencial, els teus talents innats i els desafiaments que has vingut a superar.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // --- PRODUCT TOUR (Screenshots) ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  _buildSectionHeader(context, '1. Introducció de Dades',
                      'Tot comença amb el teu nom i data de naixement.'),
                  SizedBox(height: 24),
                  _buildScreenshotContainer('assets/screenshot_input.png'),
                  SizedBox(height: 60),
                  _buildSectionHeader(
                      context,
                      '2. El Mapa de l\'Ànima (Ninot Espiritual)',
                      'Una representació visual de la teva energia.'),
                  SizedBox(height: 24),
                  _buildScreenshotContainer('assets/screenshot_figure.png'),
                  SizedBox(height: 60),
                  _buildSectionHeader(context, '3. Resultats i Cicles de Vida',
                      'Tota la informació detallada dels teus números i etapes.'),
                  SizedBox(height: 24),
                  _buildScreenshotContainer('assets/screenshot_results.png'),
                  SizedBox(height: 24),
                  _buildScreenshotContainer('assets/screenshot_cycles.png'),
                ],
              ),
            ),

            // --- AI INTERPRETATION EXAMPLE ---
            Container(
              color: Colors.indigo.shade50,
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'EXEMPLE D\'INTERPRETACIÓ (IA)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Text(
                      'A continuació mostrem un exemple real d\'anàlisi generat per la nostra Intel·ligència Artificial. Aquesta interpretació ofereix una visió profunda i immediata.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 32),
                  // Disclaimer Box
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 800),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber.shade900),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nota: Aquesta explicació és realitzada per eines d\'Intel·ligència Artificial. Tot i ser molt completa, també existeix l\'opció de sol·licitar un estudi personalitzat per un numeròleg professional (tarifa diferent).',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  // The AI Text Content
                  Container(
                    constraints: BoxConstraints(maxWidth: 800),
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownBody(
                          data: '''
Hola Francisco García Rodríguez González López,

La vibració general del teu camí de vida ressona amb el número **5**, indicant que has vingut a experimentar la llibertat, el canvi constant i la versatilitat. Ets un ésser que aprèn a través de l'experiència directa, la sensualitat i la transformació. Aquesta energia central et convida a l'aventura i a la cerca constant de noves formes d'expressió.

### Anàlisi de la Personalitat (La teva Inclusió)

El teu mapa d'inclusió revela com vius les diferents àrees de la teva existència, mostrant les teves fortaleses i els teus reptes més profunds.

**El Teu Jo i les Relacions:**
*   **Casa 1 (El teu Ego) amb Habitant 5:** La teva identitat es manifesta amb un desig innat de llibertat i canvi. T'afirmes al món buscant noves experiències, sent versàtil i evitant qualsevol lligam que pugui restringir el teu moviment o expressió. Has de vigilar l'excés d'inestabilitat o la tendència a la superficialitat.
*   **Casa 2 (Les teves Emocions) amb Habitant 0:** Aquesta és una vibració molt important, ja que el **0** en aquesta Casa indica un "Deute Kàrmic" o una lliçó pendent en l'àmbit de les emocions i les relacions. La integració de les teves emocions no és natural per a tu i requereix un treball conscient i profund. Pots experimentar dificultats amb la dependència, la submissió o, per contra, una por a la intimitat que t'impedeixi connectar autènticament. Aquest és un repte evolutiu prioritari: aprendre a gestionar i expressar les teves emocions de manera sana per desbloquejar el teu potencial en les relacions.
*   **Casa 3 (La teva Comunicació) amb Habitant 6:** T'expresses i et comuniques amb un profund sentit de l'amor, la responsabilitat i la recerca d'harmonia. Pots ser un pacificador natural, algú que busca unir i cuidar a través de les paraules. Has de vigilar, però, no caure en el sacrifici de les teves pròpies necessitats per mantenir la pau o en la possessivitat en la teva manera de relacionar-te.

**Fonaments i Món Material:**
*   **Casa 4 (Les teves Arrels i Treball) amb Habitant 1:** Construeixes la teva base i enfoques el teu treball amb esperit de lideratge, iniciativa i un fort sentit del "jo". T'agrada iniciar projectes, ser autònom i potser fins i tot el "cap" en el teu àmbit professional. Busques la teva pròpia estructura i camí.
*   **Casa 8 (Poder i Talents) amb Habitant 4:** Transformes la matèria, gestiones el poder i els teus talents amb una ment estructurada, disciplinada i treballadora. Ets capaç de construir coses sòlides i obtenir resultats tangibles gràcies a la teva constància i al teu enfocament pràctic.

**Llibertat i Amor:**
*   **Casa 5 (La teva Llibertat i Sexualitat) amb Habitant 5 (NIU!):** Aquesta és una de les teves potències més pures! Vius la llibertat, el canvi i la sexualitat d'una manera molt intensa i autèntica. Aquesta àrea de la teva vida és central per a tu i encarnes plenament l'energia del 5. La teva recerca d'experiències i la teva capacitat d'adaptació són enormes. Però, atenció als excessos: inestabilitat, impulsivitat o la tendència a dispersar-te massa.
*   **Casa 6 (El teu Amor i Família) amb Habitant 5:** La teva manera d'estimar i cuidar la família està profundament influenciada per la necessitat de llibertat i canvi. Això pot implicar que necessites espai dins de les teves relacions, que t'oposes a les estructures rígides, o que busques varietat. És crucial trobar un equilibri entre la teva necessitat de llibertat i el compromís afectiu per evitar sentir-te atrapat/da o ser inestable en l'amor.

**Espiritualitat i Visió del Món:**
*   **Casa 7 (Espiritualitat i Saviesa) amb Habitant 4:** La teva comprensió del món i la teva espiritualitat es basen en l'estructura, l'ordre i la pràctica. La teva recerca de saviesa pot implicar l'estudi sistemàtic, la creació de rituals arrelats o una connexió amb allò espiritual que es manifesta en el món material. Busques la perfecció i el coneixement a través d'una aproximació sòlida i fonamentada.
*   **Casa 9 (Transcendència i Món) amb Habitant 7:** La teva manera d'obrir-te a l'univers i transcendir es dona a través de la reflexió, l'estudi i la solitud. La teva visió del món és profundament contemplativa i filosòfica. Ets un cercador de veritats universals i t'interessa comprendre els grans interrogants de la vida. Has de vigilar, però, la tendència a l'aïllament excessiu.
*   **Casa 10 (Redueix a 1) amb Habitant 5:** La teva manera de ser pioner/a i d'iniciar nous cicles (1) està marcada per la llibertat i la transformació (5). Això reforça la teva identitat com a individu que lidera amb un esperit d'innovació i una constant obertura a l'experiència.

**Un Patró General:**
La combinació dels teus habitants amb un desequilibri entre Yin (4.5) i Yang (2) suggereix una major tendència a la receptivitat, les emocions i el processament intern, amb un possible menor impuls cap a l'acció externa o l'assertivitat. Això es pot connectar amb el desafiament kàrmic en la Casa 2, on la integració emocional és clau per equilibrar la teva energia.

### Camí de Vida i Missió

El teu **Camí de Vida 5** (ja esmentat) t'impulsa a experimentar la vida en tota la seva diversitat, a abraçar el canvi i a buscar la llibertat en totes les seves formes. La teva **Misió** a la vida, amb un **3**, et porta a expressar-te, comunicar-te i aportar alegria i creativitat al món. Has vingut a ser un canal per a la creació, l'expressió i la interacció social.

La teva **Força** més profunda, amb un **11**, és un Número Mestre. Ets un missatger diví, dotat/da d'una gran intuïció, força moral i una capacitat inspiradora. Pots sentir-te cridat/da a un propòsit superior, a il·luminar els altres amb la teva visió. Aquesta energia, present també en la teva edat de 65 anys (`any` 11) i en el dia del teu naixement (`dia` 22), et marca profundament. El **22** en la teva **Producció** indica que tens un potencial extraordinari per ser un "Constructor de Futurs", algú capaç de manifestar grans projectes amb un impacte significatiu en el món. Aquestes vibracions mestres et confereixen una gran responsabilitat i un poder de manifestació únic.

### Desafiaments i Herències

Els teus desafiaments són oportunitats de creixement prioritàries:
*   **Desafiament 1 (3):** Has de treballar la superficialitat i la dispersió en la teva comunicació i creativitat. Aprendre a enfocar la teva energia expressiva.
*   **Desafiament 2 (1):** Afrontar les teves qüestions relacionades amb l'ego, l'orgull o una possible tirania en la teva manera d'afirmar-te. Es tracta de trobar un lideratge humil i efectiu.
*   **Desafiament 3 (2):** Aquest desafiament és clau i connecta directament amb el teu Habitant 0 a la Casa 2. Consisteix a superar la dependència o la submissió en les relacions, i a trobar un equilibri en la col·laboració i la gestió emocional. És un treball profund sobre els límits personals i l'autoafirmació emocional.

Les teves **Herències** familiars també porten vibracions significatives:
*   La teva herència en la **Dimensió Materna (DM)** i l'**Eix (EJE)** mostren un fort 5, indicant que la llibertat, el canvi i la sensualitat són temes recurrents o gifts/challenges dins del teu llinatge.
*   També hi ha herències relacionades amb la comunicació i la creativitat (HHP i MS 3), amb les emocions i les relacions (NCS 2), i amb la construcció i l'estructura (MF 4). La teva herència en el **Mapa Familiar Evolutiu (MFE)** és un 7, apuntant a una cerca de saviesa i espiritualitat en el teu sistema familiar.

### Arcs de Vida

El **Primer Arc de la teva vida** (primera meitat) va estar marcat per l'expressió (7), l'obertura (9) i el desenvolupament (9). Això suggereix que els teus anys formatius van estar enfocats en la recerca de saviesa, la introspecció i l'obertura a una visió humanitària del món.
El **Segon Arc de la teva vida** (segona meitat) es centra en l'ànima (1), el renaixement (6) i l'evolució (3). Això indica una etapa posterior on el lideratge personal, els nous inicis, l'amor i la responsabilitat familiar, així com l'expressió creativa, prenen un paper protagonista en la teva evolució.

### Conclusió

El teu camí és una crida a la llibertat i a l'experimentació, recolzat per un poderós sentit de la intuïció i la capacitat de construir grans projectes. El teu principal repte, i alhora la teva major oportunitat de creixement, rau en la integració de les teves emocions i en l'establiment de relacions sanes. Afrontant el 0 en la Casa 2 i els desafiaments del 2, 3 i 1, podràs alliberar plenament el teu potencial.

Recorda que els nombres són guies, no destins inalterables. Tens la llibertat de triar com viure cada vibració, convertint els reptes en trampolins cap a la teva màxima expressió i llibertat. La teva força interior 11 i la teva capacitat inspiradora et donen les eines per superar qualsevol obstacle. Confia en la teva intuïció i abraça el canvi amb saviesa.
''',
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                            h3: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                              height: 2.0,
                            ),
                            strong: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            listBullet: TextStyle(
                              color: Colors.indigo,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48),

            // --- FAQ / CONCEPTS ---
            Container(
              color: Color(0xFFF5F5F5),
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    _buildFaqItem(
                      'Podem predir el futur?',
                      'No exactament. La numerologia no endevina què passarà demà, sinó que t\'informa del "clima" energètic. Igual que un meteoròleg et diu que plourà perquè agafis un paraigua, la carta et diu quines energies tens disponibles per a que prenguis les millors decisions.',
                    ),
                    _buildFaqItem(
                      'Què són les Herències?',
                      'Són càrregues o dons que rebem del nostre llinatge familiar (pare i mare). Identificar-les ens permet sanar patrons repetitius i alliberar el nostre veritable potencial.',
                    ),
                    _buildFaqItem(
                      'La Missió i la Força',
                      'La teva "Força" és l\'eina innata que tens per enfrontar-te al món (els teus talents naturals). La teva "Missió" és allò que has vingut a aprendre i desenvolupar, sovint allò que més et costa però que més et realitza.',
                    ),
                    _buildFaqItem(
                      'El Camí de Vida',
                      'És la "carretera" per on transita la teva vida. Pot ser un camí pla i ràpid (números dinàmics) o un camí de muntanya, lent i profund (números mestres). Conèixer-lo t\'ajuda a no frustrar-te quan les coses no van a la velocitat que voldries.',
                    ),
                  ],
                ),
              ),
            ),

            // --- CTA ---
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/public_calculator');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                ),
                child: Text(
                  'CALCULA LA TEVA CARTA',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScreenshotContainer(String assetPath) {
    return Container(
      constraints: BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }
}
