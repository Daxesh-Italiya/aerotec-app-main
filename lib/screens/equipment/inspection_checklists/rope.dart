import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/abraded.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/chemical_damage.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/chemical_damage.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/cut_gouged.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/dirt_grit_grime.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/distortion_kinks.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/elongation.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/heat_damage.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/inconsistent_diameter.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/suspect_overloading.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/uv_degredation.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/dirt_grit_grime.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/distortion_kinks.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/elongation.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/heat_damage.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/inconsistent_diameter.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/overloading.dart';
// import 'package:aerotec_flutter_app/screens/equipment/inspection_checklists/rope_checklists/uv_degredation.dart';
import 'package:flutter/material.dart';

class RopeChecklist extends StatefulWidget {

  @override
  _RopeChecklistState createState() => _RopeChecklistState();
}

class _RopeChecklistState extends State<RopeChecklist> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AbradedChecklist(),
              CutOrGougedChecklist(),
              DirtGritOrGrimeChecklist(),
              DistortionOrKinksChecklist(),
              UvDegredationChecklist(),
              ChemicalDamageChecklist(),
              HeatDamageChecklist(),
              InconsistentDiameterChecklist(),
              ElongationChecklist(),
              SuspectOverloadingChecklist(),
            ],
          ),
        ),
      ),
    );
  }

}
