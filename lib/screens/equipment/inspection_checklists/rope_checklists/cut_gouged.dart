import 'package:aerotec_flutter_app/models/equipment/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> cutOrGougedQuestions = [
  'Extensive Fiber Breakage',
  'Uniform Fiber Breakage',
  'Broken Strands',
  'Broken Fibers or Yarn'
];

class CutOrGougedChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    cutOrGougedQuestions.length,
    (index) => new RopeChecklistItem(
      name: cutOrGougedQuestions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              'Rope or Fibers are Cut or Gouged',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cutOrGougedQuestions.length,
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
