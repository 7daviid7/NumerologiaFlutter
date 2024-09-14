import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import '../ui_widgets/arc_widget.dart';
import '../ui_widgets/challenges_widget.dart';
import '../ui_widgets/family_legacies_widget.dart';
import '../ui_widgets/data_table_widget.dart';
import '../ui_widgets/name_with_values_widget.dart';
import '../ui_widgets/personality_area_widget.dart';
import '../ui_widgets/life_path_widget.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: NameWithValuesWidget(name: dataModel.name),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: DataTableWidget(tableData: dataModel.taula),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: ChallengesWidget(challenges: dataModel.mapDesafio),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 3,
                                child: FamilyHeritageWidget(values: dataModel.mapHerencies),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: PersonalityAreaWidget(personalityValues: dataModel.mapPersonalidad)),
                        SizedBox(height: 5),
                        Expanded(child: LifePathWidget(values: dataModel.mapVida, date: dataModel.date)),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ArcWidget(values: dataModel.mapPrimerArc),
                        SizedBox(height: 20),
                        ArcWidget(values: dataModel.mapSegonArc),
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
