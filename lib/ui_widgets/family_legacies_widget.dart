import 'package:flutter/material.dart';
import '../services/numerology_calculation_service.dart';

class FamilyHeritageWidget extends StatelessWidget {
  final Map<String, int> values;
  final bool isVertical;

  FamilyHeritageWidget({required this.values, this.isVertical = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Càlcul de la mida ideal basada en l'amplada
        // Càlcul de la mida ideal basada en l'amplada
        // Si és vertical, tenim menys divisió (1 columna) però volem que sigui més compacte
        double widthDivisor = isVertical ? 12 : 20;
        double widthBasedFontSize = availableWidth / widthDivisor;

        // Càlcul de la mida ideal basada en l'alçada (si és finita)
        // Si és vertical, tenim més files (7 items -> 7 files). Augmentem divisor per fer-ho més petit
        double heightDivisor = isVertical ? 40 : 13;
        double heightBasedFontSize = double.infinity;
        if (availableHeight != double.infinity) {
          heightBasedFontSize = availableHeight / heightDivisor;
        }

        // Mida óptima: la que permeti omplir l'espai més restrictiu
        double optimalFontSize = widthBasedFontSize < heightBasedFontSize
            ? widthBasedFontSize
            : heightBasedFontSize;

        // Límits
        double fontSize = optimalFontSize;
        if (fontSize < 10.0) fontSize = 10.0;
        if (fontSize > 42.0) fontSize = 42.0;

        double cardMargin = fontSize * 0.2;
        double cardElevation = 2.0;
        double iconSize = fontSize * 1.5;
        double textFontSize = fontSize;
        double spacing = fontSize * 0.3;

        Widget childContent = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // CENTRED
          children: [
            Text(
              'Herències Familiars',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textFontSize * 1.2,
              ),
            ),
            SizedBox(height: spacing),
            _buildGridLayout(cardMargin, cardElevation, iconSize, textFontSize,
                spacing, availableWidth)
          ],
        );

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(spacing),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: isVertical
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: childContent,
                )
              : SingleChildScrollView(
                  child: childContent,
                ),
        );
      },
    );
  }

  Widget _buildGridLayout(
    double cardMargin,
    double cardElevation,
    double iconSize,
    double textFontSize,
    double spacing,
    double availableWidth,
  ) {
    List<Widget> rows = [];
    List<MapEntry<String, int>> entries = values.entries.toList();
    int itemCount = entries.length;
    // Responsive Logic:
    // - If isVertical (Sidebar): 1 column.
    // - If Mobile (width < 600): 2 columns.
    // - If Desktop/Tablet: 4 columns.
    int itemsPerRow = isVertical ? 1 : (availableWidth < 600 ? 2 : 4);

    int rowCount = (itemCount / itemsPerRow).ceil();

    for (int row = 0; row < rowCount; row++) {
      List<Widget> rowItems = [];
      for (int col = 0; col < itemsPerRow; col++) {
        int index = row * itemsPerRow + col;
        if (index < itemCount) {
          String label = entries[index].key;
          int value = entries[index].value;
          int reducedValue = reduceToSingleDigit(value);

          if (isVertical) {
            // Vertical mode: Limit width explicitly
            // We want them uniform but not full width.
            // Estimate width based on font size or just allow content to define it but consistent?
            // "Limit width a little more" -> Fixed width relative to font is safest for alignment.
            // Let's use a multiple of textFontSize that fits the content comfortably (approx 10-12 chars + icon)
            double cardWidth = textFontSize * 10.0;

            rowItems.add(
              Container(
                width: cardWidth,
                child: _buildHeritageCard(
                  label,
                  value,
                  reducedValue,
                  cardMargin,
                  cardElevation,
                  iconSize,
                  textFontSize,
                ),
              ),
            );
          } else {
            // Horizontal/Grid mode: Use Expanded to fill cells
            rowItems.add(
              Expanded(
                child: _buildHeritageCard(
                  label,
                  value,
                  reducedValue,
                  cardMargin,
                  cardElevation,
                  iconSize,
                  textFontSize,
                ),
              ),
            );
          }

          if (col < itemsPerRow - 1) {
            rowItems.add(SizedBox(width: spacing)); // Espai entre columnes
          }
        } else {
          // Fill empty space if logic requires it for grid alignment,
          // but Expanded handles it well usually if we want them to stretch.
          // For now, let's keep it simple.
          rowItems.add(Spacer());
          if (col < itemsPerRow - 1) {
            rowItems.add(SizedBox(width: spacing));
          }
        }
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // CENTERED
          children: rowItems,
        ),
      );

      if (row < rowCount - 1) {
        rows.add(SizedBox(height: spacing)); // Espai entre files
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _buildHeritageCard(
    String label,
    int value,
    int reducedValue,
    double cardMargin,
    double cardElevation,
    double iconSize,
    double textFontSize,
  ) {
    bool masterNumber = isMasterNumber(reducedValue);
    int finalReducedValue =
        masterNumber ? reduceToSingleDigitResult(reducedValue) : reducedValue;

    return Card(
      margin: EdgeInsets.symmetric(vertical: cardMargin), // Màrgen vertical
      elevation: cardElevation, // Elevació de la targeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0), // Radius de les cantonades
      ),
      color: Colors.blue[100], // Color blau suau per a la targeta
      child: Padding(
        padding: const EdgeInsets.all(6.0), // Padding intern
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              color: const Color.fromARGB(255, 8, 9, 9), // Color de la icona
              size: iconSize, // Mida de la icona
            ),
            SizedBox(width: 6), // Espai entre icona i text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: textFontSize *
                          1.1, // Mida del text de l'etiqueta (increased)
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600], // Color del text
                    ),
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$value/$reducedValue ',
                          style: TextStyle(
                            fontSize: textFontSize *
                                1.5, // Mida del text del valor (increased)
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900], // Color del text
                          ),
                        ),
                        if (masterNumber)
                          TextSpan(
                            text: '($finalReducedValue)',
                            style: TextStyle(
                              fontSize: textFontSize *
                                  1.3, // Mida del text del valor reduït (increased)
                              fontWeight: FontWeight.bold,
                              color: Colors.red, // Color del text reduït
                              backgroundColor:
                                  Colors.yellow, // Color de fons per encerclar
                            ),
                          ),
                      ],
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
}
