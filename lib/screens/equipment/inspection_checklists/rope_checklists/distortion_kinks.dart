import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> distortionOrKinksChecklistQuestions = [
  'Hockles',
  'Rope is Compacted'
];

class DistortionOrKinksChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    distortionOrKinksChecklistQuestions.length,
    (index) => new RopeChecklistItem(
      name: distortionOrKinksChecklistQuestions[index],
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
              'Distortion or Kinks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: distortionOrKinksChecklistQuestions.length,
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
