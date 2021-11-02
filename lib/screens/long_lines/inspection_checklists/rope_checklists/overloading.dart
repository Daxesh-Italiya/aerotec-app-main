import 'package:aerotec_flutter_app/models/longlines/longline_checklists/rope_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> overloadingOptions = [
  'Suspect Overloading*',
  'Suspect Dynamic Loading*',
  'Suspect Chemical Exposure*',
];

class OverloadingChecklist extends StatelessWidget {
  
  final List<RopeChecklistItem> checklistItems = List.generate(
    overloadingOptions.length,
    (index) => new RopeChecklistItem(
      name: overloadingOptions[index],
      yes: false,
      no: false,
      repair: false,
      replace: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          Text(
            'Suspect Overloading*',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: overloadingOptions.length,
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
