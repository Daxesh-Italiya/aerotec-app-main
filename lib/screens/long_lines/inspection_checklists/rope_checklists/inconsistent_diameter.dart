import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> inconsistentDiameterOptions = [
  'Flat Areas',
  'Bumps or Lumps',
  'Soft or Mushy Areas',
  'Uneven, Rough or Hard Areas'
];

class InconsistentDiameterChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    inconsistentDiameterOptions.length,
    (index) => new RopeChecklistItem(
      name: inconsistentDiameterOptions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.all(20),
            child: Text(
              'Inconsistent Diameter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: inconsistentDiameterOptions.length,
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
