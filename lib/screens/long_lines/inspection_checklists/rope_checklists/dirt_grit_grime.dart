import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> dirtGritGrimQuestions = [
  'Foreign Matter Affects Handling',
  'Foreign Matter Holds Dirt/Grime'
];

class DirtGritOrGrimeChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    dirtGritGrimQuestions.length,
    (index) => new RopeChecklistItem(
      name: dirtGritGrimQuestions[index],
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
      height: 250,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              'Excessive Dirt, Grit, or Grime',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dirtGritGrimQuestions.length,
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
