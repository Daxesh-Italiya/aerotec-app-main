import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment/longline_checklists/standard_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EyeSplicesChecklist extends StatefulWidget {
  @override
  _EyeSplicesChecklistState createState() => _EyeSplicesChecklistState();
}

class _EyeSplicesChecklistState extends State<EyeSplicesChecklist> {
  List<StandardChecklistItem> checklistItems = List.generate(
    eyeSplicesQuestions.length,
    (index) => new StandardChecklistItem(
        name: eyeSplicesQuestions[index],
        yes: false,
        no: false,
        repair: false,
        remove: false),
  );


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: eyeSplicesQuestions.length,
                itemBuilder: (context, index) {
                  return ChecklistItemWidget(
                      comments: false,
                      checklistItem: checklistItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> eyeSplicesQuestions = [
  'Properly Installed',
  'No Slippage',
  'Thimble is Snug and Cannot Rotate or Fall Out',
  'Any Damage at the Leg Juncture',
  'Any Damage at the Apex',
  'Any Damage at the Ourside or Back of the Eye',
  'Flattening ir Surface Wear',
  'Lockstitch Thread Broken or Damaged',
  'Whipping Thread Broken or Damage',
  'Other Conditions, including Visible Damage, that causes doubt as to continued use'
];
