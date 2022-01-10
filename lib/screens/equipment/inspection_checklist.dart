import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/electrical_mechanical.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/eye_splices.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/identification_tag.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/supplemental_equipment.dart';
import 'package:flutter/material.dart';

class InpsectionChecklists extends StatefulWidget {
  @override
  _InpsectionChecklistsState createState() => _InpsectionChecklistsState();
}

class _InpsectionChecklistsState extends State<InpsectionChecklists> {

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(
            'LONG LINE INSPECTION',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        body: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Material(
                color: Colors.grey[600],
                child: TabBar(
                  indicatorColor: AppTheme.secondary,
                  isScrollable: true,
                  labelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  tabs: [
                    Tab(text: 'ID(TAG)'),
                    Tab(text: 'Eye Splices'),
                    Tab(text: 'Rope'),
                    Tab(text: 'Supplemental Equipment'),
                    Tab(text: 'Electrical or Mechanical Components'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    IdentificationTagChecklist(),
                    EyeSplicesChecklist(),
                    RopeChecklist(),
                    SupplementalChecklist(),
                    ElectricalMechanicalChecklist(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
