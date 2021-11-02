import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> abradedQuestions = [
  'Fuzzy yarn, fiber or strands',
  'Frayed yarn, fiber or strands',
  'Powdred Fiber'
];

class AbradedChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    abradedQuestions.length,
    (index) => new RopeChecklistItem(
      name: abradedQuestions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      height: 340,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              'Rope or Fibers are Abraded',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: abradedQuestions.length,
              itemBuilder: (context, index) {
                return RopeChecklistItemWidget(
                  comments: false,
                  checklistItem: checklistItems[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
