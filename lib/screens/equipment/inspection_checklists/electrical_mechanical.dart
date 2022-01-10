import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment/longline_checklists/comments_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> supplementalOptions = [
  'Exposed, Damaged and/or Stripped Wires or Cables',
  'Broken Plugs or Fittings',
  'Evidence of Unauthorized Modifications',
  'Damage from Improper Storage',
  'Other Conditions, including Visible Damage, that Causes doubt as to Continued Use.'
];

class ElectricalMechanicalChecklist extends StatefulWidget {
  @override
  _ElectricalMechanicalChecklistState createState() => _ElectricalMechanicalChecklistState();
}

class _ElectricalMechanicalChecklistState extends State<ElectricalMechanicalChecklist> {


  List<CommentsChecklistItem> checklistItems = List.generate(
    supplementalOptions.length,
    (index) => new CommentsChecklistItem(
        name: supplementalOptions[index],
        yes: false,
        no: false,
        repair: false,
        remove: false,
        comments: '',
      ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   color: Colors.grey[300],
          //   padding: EdgeInsets.all(20),
          //   child: Text(
          //     'Electrical or Mechanical Components',
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16.0,
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: supplementalOptions.length,
              itemBuilder: (context, index) {
                return CommentsChecklistItemWidget(
                  lastIndex: supplementalOptions.length,
                  index: index,
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
