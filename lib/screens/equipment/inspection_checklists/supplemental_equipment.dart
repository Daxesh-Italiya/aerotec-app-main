import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment/longline_checklists/comments_checklist_item.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

List<String> supplementalOptions = [
  'Tears, Cuts, Punctures to the Cover Material',
  'Broken Seams',
  'The Following Items are Functional and Undamaged',
  'Zippers',
  'Hook and Loop (Velcro*)',
  'Retaining Straps',
  'Circumferential Tie Wraps',
  'Buckles',
  'Other Adjustment or Tightening Devices',
  'Evidence of Unauthorized Modifications',
  'Damage from Improper Storage',
  'Weighted Line Cover Material is Damaged Exposing Weight Bags',
  'Weights are Secured and Cannot Slip Out',
  'Other Conditions, including Visible Damage, that Causes Doubt as to Continued Use'
];

class SupplementalChecklist extends StatefulWidget {
  @override
  _SupplementalChecklistState createState() => _SupplementalChecklistState();
}

class _SupplementalChecklistState extends State<SupplementalChecklist> {

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
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Text(
              // 'Supplemental Equipment',
              'For Primary, Secondary & Weighted Line Covers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   color: Colors.grey[300],
          //   padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
          //   child: Text(
          //     'For Primary, Secondary and Weighted Line Covers',
          //     style: TextStyle(
          //       color: Colors.black54,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 14.0,
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
