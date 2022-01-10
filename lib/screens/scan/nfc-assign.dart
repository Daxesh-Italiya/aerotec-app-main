import 'dart:async';
import 'dart:convert';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
import 'package:aerotec_flutter_app/providers/equipment_provider.dart';
import 'package:aerotec_flutter_app/screens/equipment/equipment_card.dart';
import 'package:aerotec_flutter_app/screens/equipment/equipment_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

class NFC_Assign extends StatefulWidget {
  final EquipmentModel equipment;

  const NFC_Assign({required EquipmentModel this.equipment});
  @override
  _NFC_AssignState createState() => _NFC_AssignState();
}

class _NFC_AssignState extends State<NFC_Assign> {

  late EquipmentModel equipment;
  bool isScanning = true;

  void initState() {
    super.initState();
    equipment = widget.equipment;
    startScanning();
  }

  toggleWriting() {
    if (isScanning) {
      stopWriting();
    } else {
      startScanning();
    }
  }
  startScanning() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      setState(() => isScanning = true);

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          // Do something with an NfcTag instance.
          print("read NDEF message: ${tag.data}");

          Ndef? ndef = Ndef.from(tag);
          var record = ndef?.cachedMessage?.records.first;
          var decodedPayload = ascii.decode(record!.payload);
          var value = decodedPayload.substring(decodedPayload.indexOf('en') + 2);
          print(value);

          EquipmentProvider equipmentProvider = Provider.of<EquipmentProvider>(context, listen: false);

          equipment.fields['nfc_id'] = value;
          await equipmentProvider.updateListing(equipment);

          Fluttertoast.showToast(
            msg: "NFC Tag Assigned",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0
          );
          Navigator.pop(context);
        },
      );
    }
  }
  stopWriting() {
    setState(() => isScanning = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          onPressed: () => toggleWriting(),
          child: ImageIcon(
            AssetImage('images/rssnew.png'),
            size: 32,
          )
        ),
      ),
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: (isScanning) ? Colors.green : Colors.grey,
              title: Text('ASSIGN NFC',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              expandedHeight: 230,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 100, 60, 20),
                  // child: ImageIcon(AssetImage('images/rssnew.png'),size: 32,),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => toggleWriting(),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: ImageIcon(AssetImage('images/rssnew.png'),size: 28, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text((isScanning) ? 'READY TO SCAN' : 'TAP TO SCAN', style: GoogleFonts.benchNine(fontSize: 38, color: Colors.white)),
                        Text((isScanning) ? '(tap to pause)' : '', style: TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              )
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // Components --------------------------------------------------------
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(11, 9, 9, 9),
                      child: Text('Assign NFC tag to this Equipment:', style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),

                    // Add --------------------------------------------------------

                    // RoundIconButton(
                    //   icon: Icons.add_outlined,
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => EquipmentForm(equipment: null, formType: 'new'),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                )
              ),
            ),
            Consumer<EquipmentProvider>(
              builder: (context, provider, child) {
                return SliverList(delegate: SliverChildBuilderDelegate((_, int index) {
                    final EquipmentModel equipment = provider.equipmentList[index];
                    return EquipmentCard(equipment: equipment, index: index, link: 0);
                  },
                  childCount: provider.equipmentList.length,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
