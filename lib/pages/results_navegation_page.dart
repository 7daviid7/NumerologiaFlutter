import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import '../services/pdf/pdf_service.dart';
import 'results_page.dart';
import 'spiritual_figure_page.dart';
import 'life_cycles_page.dart';
import 'ai_interpretation_page.dart';

class ResultsNavigatorPage extends StatefulWidget {
  @override
  ResultsNavigatorPageState createState() => ResultsNavigatorPageState();
}

class ResultsNavigatorPageState extends State<ResultsNavigatorPage> {
  final GlobalKey _globalKey = GlobalKey();
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // The number of tabs
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white, // Background color for TabBar
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // Implement the back navigation logic
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          _selectedPageIndex = index;
                        });
                      },
                      tabs: [
                        Tab(text: 'Resultats Principals'),
                        Tab(text: 'Cicles de Vida'),
                        Tab(text: 'Ninot Espiritual'),
                        Tab(text: 'Interpretació IA'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () async {
                      final dataModel =
                          Provider.of<DataModel>(context, listen: false);
                      final printService = PrintService();

                      if (_selectedPageIndex == 1) {
                        // Imprimir només Cicles de Vida
                        await printService.printLifeCyclesPdf(dataModel);
                      } else if (_selectedPageIndex == 2) {
                        // Imprimir només Ninot Espiritual
                        await printService.printSpiritualFigurePdf(dataModel);
                      } else if (_selectedPageIndex == 3) {
                        // Imprimir Interpretació IA
                        await printService.printAiInterpretationPdf(dataModel);
                      } else {
                        // Imprimir l'informe complet (Resultats Principals)
                        await printService.printFullReportPdf(dataModel);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: RepaintBoundary(
                key: _globalKey,
                child: IndexedStack(
                  index: _selectedPageIndex,
                  children: [
                    ResultsPage(),
                    LifeCyclesPage(),
                    SpiritualFigurePage(),
                    AIInterpretationPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
