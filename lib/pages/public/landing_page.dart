import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:numerologia/pages/public/chart_explanation_page.dart'; // Corrected package name
import '../../data/numerology_content.dart';
import '../../services/history_service.dart';
import '../../widgets/pwa_install_prompt.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final HistoryService _historyService = HistoryService();

  // Dades numerològiques mogudes a data/numerology_content.dart

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Definir colors i estils bàsics
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: primaryColor, size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Numerologia Professional',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                    tooltip: 'Accés Professional',
                    onPressed: _navigateToLogin,
                  ),
                ],
              ),
            ),

            // --- HERO SECTION ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A237E), // Deep Indigo
                    Color(0xFF3949AB), // Lighter Indigo
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: CustomPaint(
                        painter: GridPainter(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 100, horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          'NUMEROLOGIA',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'La Ciència dels Símbols',
                          textAlign: TextAlign.center,
                          style: textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 24),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Text(
                            '"Si vols conèixer els secrets de l’Univers, pensa en termes d’energia, freqüència i vibració."',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '- Nikola Tesla',
                          style: TextStyle(color: Colors.white54),
                        ),
                        SizedBox(height: 48),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/public_calculator'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1A237E),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'CALCULA EL TEU CAMÍ DE VIDA (GRATIS)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- ORIGENS & DEFINICIÓ ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  _buildSectionTitle(context, 'L\'Art d\'Interpretar Símbols'),
                  SizedBox(height: 40),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 900),
                    child: Text(
                      'La numerologia no és només matemàtiques. És una creença ancestral que estableix una relació mística entre els nombres, els éssers vius i les forces espirituals. Ens ensenya a sentir els números com una vibració.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Wrap(
                    spacing: 40,
                    runSpacing: 40,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildInfoCard(
                        context,
                        title: 'Pitàgores',
                        subtitle: 'El Pare Matemàtic',
                        description:
                            'Veia en pautes numèriques l\'explicació dels fenòmens naturals. Pels pitagòrics, tot és número.',
                        icon: Icons.functions,
                      ),
                      _buildInfoCard(
                        context,
                        title: 'La Càbala',
                        subtitle: 'L\'Arbre de la Vida',
                        description:
                            'Un mapa de l\'ànima compostat per 10 Sefirots (esferes) que representen arquetips divins i el camí de la creació.',
                        icon: Icons.account_tree, // Tree semblance
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- FONAMENTS DE LA NUMEROLOGIA (New Section) ---
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              width: double.infinity,
              child: Column(
                children: [
                  _buildSectionTitle(context, 'Fonaments de la Numerologia'),
                  SizedBox(height: 16),
                  Text(
                    'La base teòrica del sistema NUMEN.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  SizedBox(height: 48),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: NumerologyContent.foundations.map((item) {
                      return _buildInfoCard(
                        context,
                        title: item.title,
                        subtitle: item.shortDesc,
                        description: item.fullDesc,
                        icon: item.icon,
                        color: item.color,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // --- YIN & YANG ---
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              width: double.infinity,
              child: Column(
                children: [
                  _buildSectionTitle(context, 'Dualitat Universal: Yin & Yang'),
                  SizedBox(height: 16),
                  Text(
                    'Tots els números tenen una naturalesa energètica.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  SizedBox(height: 60),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 800;
                      return Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildYinYangCard(
                            context,
                            isYang: true,
                            numbers: '1, 3, 5, 7, 9',
                            title: 'YANG',
                            elements: 'FOC i AIRE',
                            description:
                                'Energia masculina, activa i mental. Són independents, líders i es projecten cap a l\'exterior.',
                            color: Color(0xFFE53935), // Red
                          ),
                          if (isMobile)
                            SizedBox(height: 24)
                          else
                            SizedBox(width: 40),
                          _buildYinYangCard(
                            context,
                            isYang: false, // Yin
                            numbers: '2, 4, 6, 8',
                            title: 'YIN',
                            elements: 'TERRA i AIGUA',
                            description:
                                'Energia femenina, receptiva i emocional. Privilegien la vida interior, la col·laboració i l\'estabilitat.',
                            color: Color(0xFF1E88E5), // Blue
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // --- CARTA NUMEROLÒGICA (Teaser) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  _buildSectionTitle(context, 'La Carta Numerològica'),
                  SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Text(
                      'Més que una predicció, és un mapa de l\'ànima. Descobreix la teva Missió, la teva Força i el teu Camí de Vida.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/chart_explanation'),
                    icon: Icon(Icons.description, size: 20),
                    label: Text('VEURE UN EXEMPLE COMPLET'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // --- DESC & SIMBOLISME (Formerly Archetypes) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  _buildSectionTitle(
                      context, 'Descripció i Simbolisme dels Números'),
                  SizedBox(height: 16),
                  Text(
                    'Fes clic en cada número per descobrir el seu significat profund.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  SizedBox(height: 48),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: NumerologyContent.basicNumbers.map((item) {
                      return _buildNumberCard(context, item);
                    }).toList(),
                  ),
                ],
              ),
            ),

            // --- NOMBRES MESTRES (New Section) ---
            Container(
              color: Color(0xFFFFF8E1), // Light Gold background
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              width: double.infinity,
              child: Column(
                children: [
                  _buildSectionTitle(context, 'Els Nombres Mestres'),
                  SizedBox(height: 16),
                  Text(
                    'Energies superiors que requereixen un gran aprenentatge.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.brown.shade800,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 48),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: NumerologyContent.masterNumbers.map((item) {
                      return _buildNumberCard(context, item, isMaster: true);
                    }).toList(),
                  ),
                ],
              ),
            ),

            // --- L'ARBRE DE LA VIDA (Sefirot) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  _buildSectionTitle(context, 'L\'Arbre de la Vida (Càbala)'),
                  SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Text(
                      'Els 10 Sefirot representen les emanacions divines i el camí de realització espiritual.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: NumerologyContent.sefirot.map((item) {
                      return _buildSefirotCard(context, item);
                    }).toList(),
                  ),
                ],
              ),
            ),

            // --- LA INCLUSIÓ (Method) ---
            Container(
              color: Color(0xFF1A1A1A), // Dark background for contrast
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'LA INCLUSIÓ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
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
                  SizedBox(height: 32),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Column(
                      children: [
                        Text(
                          'Un camí d\'autoconeixement a través de 9 aspectes de la vida.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 32),
                        Text(
                          'La Inclusió es basa en assignar un valor numèric a cada lletra del teu nom complet per descobrir quins números (Habitants) ocupen les 9 Cases de la teva vida.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 48),
                        _buildLetterValueTable(context),
                        SizedBox(height: 48),
                        Text(
                          'Cada "Casa" representa una àrea de la vida, i el número que l\'habita (l\'Habitant) ens indica com vivim aquesta àrea:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1200),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: NumerologyContent.houses.map((item) {
                        return _buildHouseCard(context, item);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // --- TESTIMONIALS SECTION ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              width: double.infinity,
              child: Column(
                children: [
                  _buildSectionTitle(context, 'Testimonis'),
                  SizedBox(height: 40),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _historyService.getPublicTestimonials(limit: 6),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('No s\'han pogut carregar els testimonis.');
                      }

                      final testimonials = snapshot.data ?? [];
                      if (testimonials.isEmpty) {
                        return Text(
                            'Encara no hi ha testimonis públics disponibles.');
                      }

                      return Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: testimonials.map((data) {
                          final name = data['fullName'] ?? 'Anònim';
                          final text = data['interpretation'] ?? '';
                          // We use safe parsing for rating, defaulting to 5.0 if missing or error
                          final rating = (data['rating'] is num)
                              ? (data['rating'] as num).toDouble()
                              : 5.0;

                          // Agafem només un fragment petit del text com a "cita"
                          final shortText = text.length > 100
                              ? text.substring(0, 100) + '...'
                              : text;

                          return Container(
                            width: 300,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          primaryColor.withOpacity(0.2),
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '"$shortText"',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: 12),
                                RatingBarIndicator(
                                  rating: rating,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // --- FOOTER ---
            Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Numerologia Professional',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Contacte: info@numerologia.com',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '© 2025 Tots els drets reservats.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: IosInstallPrompt(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
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
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required String subtitle,
      required String description,
      required IconData icon,
      Color? color}) {
    return Container(
      width: 350,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color ?? Theme.of(context).primaryColor),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildYinYangCard(BuildContext context,
      {required bool isYang,
      required String numbers,
      required String title,
      required String elements,
      required String description,
      required Color color}) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              numbers,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            elements,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400]),
          ),
          SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCard(BuildContext context, NumerologyItem item,
      {bool isMaster = false}) {
    return InkWell(
      onTap: () => _showDetailDialog(
        context,
        title: item.title,
        content: item.fullDesc,
        subTitle: item.shortDesc,
        icon: item.icon,
        color: item.color,
        bodyPart: item.bodyPart,
        excessTrap: item.excessTrap,
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: isMaster ? 280 : 160, // Wider for master numbers
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isMaster
                ? [Colors.white, item.color.withOpacity(0.1)]
                : [Colors.white, item.color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: item.color.withOpacity(isMaster ? 0.6 : 0.3),
              width: isMaster ? 2.5 : 1.5), // Thicker border for master
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.15),
              blurRadius: isMaster ? 20 : 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Text(
                item.id,
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w900,
                  color: item.color.withOpacity(0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: isMaster
                          ? Border.all(color: item.color, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        item.id,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: item.color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    item.title.split(' / ')[0], // Show short title
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Veure més',
                    style: TextStyle(
                      fontSize: 12,
                      color: item.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSefirotCard(BuildContext context, NumerologyItem item) {
    return InkWell(
      onTap: () => _showDetailDialog(
        context,
        title: item.title,
        content: item.fullDesc,
        subTitle: item.shortDesc,
        icon: item.icon,
        color: item.color == Colors.white
            ? Colors.grey.shade400
            : item.color, // Handle white visibility
        angel: item.angel,
        planet: item.planet,
      ),
      borderRadius: BorderRadius.circular(100), // Circular cards for Sefirot
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: item.color == Colors.white
                ? Colors.grey.shade300
                : item.color.withOpacity(0.5),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon,
                color: item.color == Colors.white
                    ? Colors.grey.shade400
                    : item.color,
                size: 32),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.title.split(': ')[0], // Kether, Hochmah...
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              item.id,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseCard(BuildContext context, NumerologyItem item) {
    return InkWell(
      onTap: () => _showDetailDialog(
        context,
        title: item.title,
        content: item.fullDesc,
        subTitle: item.shortDesc,
        icon: item.icon,
        color: item.color,
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: item.color.withOpacity(0.5), width: 2),
                color: item.color.withOpacity(0.2),
              ),
              child: Text(
                item.id,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.title.replaceAll('Casa ${item.id}: ', ''), // Short title
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 4),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context,
      {required String title,
      required String content,
      String? subTitle,
      IconData? icon,
      Color color = Colors.blue,
      String? bodyPart,
      String? excessTrap,
      String? angel,
      String? planet}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with color
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 32, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (subTitle != null) ...[
                        Text(
                          subTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                      Text(
                        content,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                      ),
                      if (bodyPart != null) ...[
                        SizedBox(height: 24),
                        _buildInfoSection('Cos Humà', bodyPart,
                            Icons.accessibility_new, color),
                      ],
                      if (excessTrap != null) ...[
                        SizedBox(height: 16),
                        _buildInfoSection('Trampes de l’Excés', excessTrap,
                            Icons.warning_amber_rounded, Colors.red.shade400),
                      ],
                      if (angel != null) ...[
                        SizedBox(height: 16),
                        _buildInfoSection(
                            'Arcàngel', angel, Icons.flutter_dash, color),
                      ],
                      if (planet != null) ...[
                        SizedBox(height: 16),
                        _buildInfoSection(
                            'Planeta', planet, Icons.public, Colors.blueGrey),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text('Tancar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Old Feature Card (Deprecated for now or reused)
  Widget _buildFeatureCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return SizedBox.shrink();
  }

  Widget _buildLetterValueTable(BuildContext context) {
    // Data from the user's table
    final Map<int, String> letters = {
      1: 'A, J, S',
      2: 'B, K, T',
      3: 'C, L, U',
      4: 'D, M, V',
      5: 'E, N, W',
      6: 'F, O, X',
      7: 'G, P, Y',
      8: 'H, Q, Z',
      9: 'I, R',
    };

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            'TAULA DE CONVERSIÓ (LLETRES A NÚMEROS)',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0),
          ),
          SizedBox(height: 24),
          Table(
            border: TableBorder(
              horizontalInside:
                  BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Header Row
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Número',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Lletres',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
              // Data Rows
              ...letters.entries.map((entry) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        entry.key.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
