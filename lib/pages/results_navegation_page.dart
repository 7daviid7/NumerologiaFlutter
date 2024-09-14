import 'package:flutter/material.dart';
import 'results_page.dart';
import 'spiritual_figure_page.dart'; 
import 'life_cycles_page.dart'; 
import '../services/print_preview_dialog.dart';

class ResultsNavigatorPage extends StatefulWidget {
  @override
  ResultsNavigatorPageState createState() => ResultsNavigatorPageState();
}

class ResultsNavigatorPageState extends State<ResultsNavigatorPage> {
  
  final GlobalKey _globalKey = GlobalKey();
  final PrintPreviewDialog _printPreviewDialog = PrintPreviewDialog();
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,  // The number of tabs
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
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () => _printPreviewDialog.showPreviewAndPrint(
                      context, _globalKey, 'Resultats de Numerologia'), // Print preview dialog
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
