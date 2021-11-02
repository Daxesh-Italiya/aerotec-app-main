import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longline_checklists/standard_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class IdentificationTagChecklist extends StatefulWidget {
  
  @override
  _IdentificationTagChecklistState createState() =>
      _IdentificationTagChecklistState();
}

class _IdentificationTagChecklistState extends State<IdentificationTagChecklist> {
  
  List<StandardChecklistItem> checklistItems = List.generate(
    identificationQuestions.length,
    (index) => new StandardChecklistItem(
        name: identificationQuestions[index],
        yes: false,
        no: false,
        repair: false,
        remove: false,
    ),
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
                itemCount: identificationQuestions.length,
                itemBuilder: (context, index) {
                  return ChecklistItemWidget(
                    comments: false,
                    checklistItem: checklistItems[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> identificationQuestions = [
  'Sling Identification (Tag) and Warnings Legible',
  'Tag Wrap is Operational',
  'Tag Must Contain the Following Information: ',
  'Name or Trademark of Manufacturer',
  'Name or Trademark of Repair Entity if Repairs Were Done',
  'Stock Number',
  'Material Used in the Long Line',
  'Rope Diameter',
  'Length',
  'Date of Manufacturer',
  'Date of Repair',
  'Serial Number',
  'Work Load Limit',
  'Inspection Dates Marked on Tag',
  'Warning Information Complete and Legible',
  'Damaging Metal Tags and/or Metal Cable Present'
];
