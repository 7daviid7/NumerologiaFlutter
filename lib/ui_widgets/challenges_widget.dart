import 'package:flutter/material.dart';

class ChallengesWidget extends StatelessWidget {
  final Map<String, int> challenges; // Map que conté els desafiaments

  ChallengesWidget({required this.challenges});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Obtenim l'espai disponible
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;
        int widthDivisible = availableHeight.toInt() <= 185 ? 18 : 12;
        // Calculem quants elements tenim per saber quant espai vertical necessitem
        int itemCount = challenges.length;
        // Estimació de "files" lògiques: Títol (2) + Cada item (3 unitats d'alçada aprox amb marges) + Padding (1)
        double logicalRows = 2.0 + (itemCount * 3.5) + 1.0;

        // Càlcul de la mida ideal basada en l'amplada
        double widthBasedFontSize =
            availableWidth / widthDivisible; // Aprox caracters per línia

        // Càlcul de la mida ideal basada en l'alçada
        double heightBasedFontSize = double.infinity;
        if (availableHeight != double.infinity) {
          heightBasedFontSize = availableHeight / logicalRows;
        }

        // Triem la mida més restrictiva, però sense ser tan conservadors amb el min() rígid
        // Volem omplir l'espai
        double optimalFontSize = widthBasedFontSize < heightBasedFontSize
            ? widthBasedFontSize
            : heightBasedFontSize;

        // Límits:
        // Mínim 10: Per sota d'això activem scroll.
        // Màxim 28: Per sobre d'això es veu massa gran.
        double fontSize = optimalFontSize;
        if (fontSize < 12.0) fontSize = 10.0;
        if (fontSize > 18.0) fontSize = 15.0;

        double titleFontSize = fontSize * 1.3;
        double itemFontSize = fontSize * 0.9;
        double iconSize = fontSize * 1.5;
        double spacing = fontSize * 0.3;
        double padding = fontSize * 0.4;

        TextStyle titleTextStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: titleFontSize,
        );

        TextStyle itemTextStyle = TextStyle(
          fontSize: itemFontSize,
        );

        TextStyle valueTextStyle = TextStyle(
          fontSize: itemFontSize,
          color: Colors.blue[900],
        );

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Desafiaments',
                style: titleTextStyle,
              ),
              SizedBox(height: spacing),
              Flexible(
                // Canviat d'Expanded a Flexible
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Important perquè s'encongeixi
                    children: challenges.entries.map((entry) {
                      return _buildChallengeItem(
                        entry.key,
                        entry.value,
                        itemTextStyle,
                        valueTextStyle,
                        iconSize,
                        spacing,
                        padding,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallengeItem(
    String challenge,
    int value,
    TextStyle textStyle,
    TextStyle valueTextStyle,
    double iconSize,
    double spacing,
    double padding,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacing), // Margin entre elements
      padding: EdgeInsets.symmetric(
          vertical: padding, horizontal: padding), // Padding entre text i borde
      decoration: BoxDecoration(
        color: Colors.blue[50], // Color de fons
        borderRadius: BorderRadius.circular(4.0), // Radi fix del bord
        border: Border.all(color: Colors.blue, width: 1), // Color del borde
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Espai entre text i valor
        children: [
          // Icona per a cada desafiament
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.blue[300], // Color de la icona
            size: iconSize, // Mida de la icona
          ),
          SizedBox(width: spacing), // Espai entre icona i text
          // Nom del desafiament
          Expanded(
            child: Text(
              challenge,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold), // Estil del text
            ),
          ),
          // Valor del desafiament
          Text(
            value.toString(),
            style: valueTextStyle.copyWith(
                fontWeight: FontWeight.bold), // Estil del valor
          ),
        ],
      ),
    );
  }
}
