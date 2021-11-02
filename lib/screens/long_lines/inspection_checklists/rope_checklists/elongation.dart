import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> elongationOptions = [
  'Evidence Permanent Elongation from Creep*',
  'Evidence of Unathorized Modifications',
  'Damage from Improper Storage',
  'Long Line Servie for more than Four(4) Years',
  'Long Line in Service for more than 2000 hours',
  'Other Conditions, including Visible Damage, that Causes doubt as to Continued Use'
];

class ElongationChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    elongationOptions.length,
    (index) => new RopeChecklistItem(
      name: elongationOptions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 720,
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              'Excessive Permanent Elongation from Creep*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: elongationOptions.length,
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
