import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> suspectOverloadingOptions = [
  'Suspect Overloading*',
  'Suspect Dynamic Exposure*',
  'Suspect Chemical Exposure*'
];

class SuspectOverloadingChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    suspectOverloadingOptions.length,
    (index) => new RopeChecklistItem(
      name: suspectOverloadingOptions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              '* Consult with Pilot and Review Flight Log/Records',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suspectOverloadingOptions.length,
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
