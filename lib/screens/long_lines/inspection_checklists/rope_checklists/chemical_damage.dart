import 'package:aerotec_flutter_app/models/longlines/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> chemicalDamageChecklistQuestions = [
  'Rope is Severely Discolored',
  'Melting or Bonding of Fibers or Strands',
  'Hardening',
  'Stickiness',
  'Exposure to Rust',
];

class ChemicalDamageChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    chemicalDamageChecklistQuestions.length,
    (index) => new RopeChecklistItem(
      name: chemicalDamageChecklistQuestions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              'Chemical Damage',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chemicalDamageChecklistQuestions.length,
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
