import 'dart:developer';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/category_model.dart';
import 'package:aerotec_flutter_app/models/equipment_model.dart';
import 'package:aerotec_flutter_app/models/field_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
import 'package:aerotec_flutter_app/providers/equipment_provider.dart';
import 'package:aerotec_flutter_app/screens/equipment/inspection_checklist.dart';
import 'package:aerotec_flutter_app/screens/equipment/equipment_form.dart';
import 'package:aerotec_flutter_app/screens/scan/nfc-assign.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EquipmentDetails extends StatefulWidget {
  final String id;

  const EquipmentDetails({@required required this.id});

  _EquipmentDetailsState createState() => _EquipmentDetailsState();
}

class _EquipmentDetailsState extends State<EquipmentDetails> {
  late EquipmentModel equipmentInfo;
  late EquipmentProvider equipmentProvider;
  bool tile1 = false;
  bool tile2 = false;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    equipmentProvider = Provider.of<EquipmentProvider>(context);
    equipmentInfo =
        equipmentProvider.equipmentList.singleWhere((element) => element.id == widget.id);

    print(equipmentInfo);

    CategoriesProvider categoryProvider = Provider.of<CategoriesProvider>(context);
    CategoryModel category =
        categoryProvider.categories.firstWhere((e) => e.id == equipmentInfo.fields['category_id']);
    List<Field> fields = category.fields.where((e) => e.mainType == 'details').toList();

    DateFormat formatter = DateFormat('MMMM dd, yyyy');
    var inspectionDate = this.equipmentInfo.fields['inspectionDate'] != null
        ? formatter.format(this.equipmentInfo.fields['inspectionDate'].toDate())
        : '';
    var nextInspection = this.equipmentInfo.fields['nextInspectionDate'] != null
        ? formatter.format(this.equipmentInfo.fields['nextInspectionDate'].toDate())
        : '';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(
            'EQUIPMENT DETAIL',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              /* PRE-USE INSPECTION -----------------------------------------------------------------*/

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Header(equipmentInfo: this.equipmentInfo),
                  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        initiallyExpanded: true,
                        onExpansionChanged: (val) {
                          setState(() => tile1 = val);
                        },
                        title: Text('Pre-Use Inspection'),
                        children: [
                          Container(
                            color: Colors.white,
                            child: ListTile(
                                tileColor: Colors.white,
                                trailing: Icon(Icons.chevron_right),
                                title: Text(
                                  'Perform Pre-Use Inspection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /* EQUIPMENT DETAILS -----------------------------------------------------------------*/

                  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        initiallyExpanded: true,
                        onExpansionChanged: (val) {
                          setState(() => tile1 = val);
                        },
                        title: Text(
                          this.equipmentInfo.fields['name'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: fields.length,
                              itemBuilder: (_, index) {
                                if (fields[index].name! == 'name') return Container();
                                return Container(
                                  color: Colors.white,
                                  child: ListTile(
                                      dense: true,
                                      tileColor: Colors.white,
                                      title: Row(
                                        children: [
                                          Text(fields[index].label! + ': ',
                                              style: TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.bold)),
                                          Text(
                                            equipmentInfo.fields[fields[index].name],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      )),
                                );
                              }),
                          if (equipmentInfo.fields['nfc_id'] != null)
                            Container(
                                color: Colors.white,
                                child: ListTile(
                                    dense: true,
                                    tileColor: Colors.white,
                                    title: Row(
                                      children: [
                                        Text('NFC Tag: ',
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.bold)),
                                        Text(
                                          equipmentInfo.fields['nfc_id'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    )))
                        ],
                      ),
                    ),
                  ),

                  /* PERIODIC INSPECTION -----------------------------------------------------------------*/

                  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        initiallyExpanded: true,
                        onExpansionChanged: (val) {
                          setState(() => tile1 = val);
                        },
                        title: Text('Periodic Inspection'),
                        children: [
                          Container(
                            color: Colors.white,
                            child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InpsectionChecklists()));
                                },
                                tileColor: Colors.white,
                                trailing: Icon(Icons.chevron_right),
                                leading: Container(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset('images/checkmark.png'),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      'Last Inspection: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      inspectionDate,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Divider(height: 1),
                          Container(
                            color: Colors.white,
                            child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InpsectionChecklists()));
                                },
                                tileColor: Colors.white,
                                leading: Container(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset('images/alert.png'),
                                ),
                                trailing: Icon(Icons.chevron_right),
                                title: Row(
                                  children: [
                                    Text(
                                      'Next Due: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      nextInspection,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        initiallyExpanded: true,
                        onExpansionChanged: (val) {
                          setState(() => tile2 = val);
                        },
                        title: Text('Last Known Location'),
                        children: [
                          Container(
                              height: 200,
                              color: Colors.white,
                              padding: EdgeInsets.all(8),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(37.42796133580664, -122.085749655962),
                                  zoom: 14.4746,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            ),
            if (equipmentProvider.isLoading) LoadingOverlay()
          ],
        ));
  }
}

class Header extends StatelessWidget {
  final EquipmentModel equipmentInfo;

  const Header({Key? key, required this.equipmentInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> filename = equipmentInfo.fields['filename']?.split('.') ?? [null];
    String? imageUrl = filename[0];

    return Container(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            Positioned(
                right: 10,
                top: 40,
                child: PopupMenuButton(
                  child: Icon(Icons.more_vert, size: 40, color: Colors.grey),
                  offset: Offset(-20, 40),
                  onSelected: (val) {
                    switch (val) {
                      case 0:
                        {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EquipmentForm(equipment: this.equipmentInfo, formType: 'edit')));
                          break;
                        }
                      case 1:
                        {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NFC_Assign(equipment: this.equipmentInfo)));
                          break;
                        }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Modify Details'), value: 0),
                    PopupMenuItem(child: Text('Assign NFC Tag'), value: 1),
                  ],
                )),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                // alignment: Alignment.bottomRight,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      width: 150,
                      height: 150,
                      child: ClipOval(
                        child: imageUrl == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('N/A',
                                      style:
                                          TextStyle(height: 1, fontSize: 20, color: Colors.white)),
                                ],
                              )
                            : CachedNetworkImage(
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/aerotec%2Fequipment%2F${imageUrl.toString()}_800x800.jpeg?alt=media',
                                width: 125,
                                height: 125,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (equipmentInfo.fields['nfc_id'] != null)
                    Positioned(
                        bottom: 15,
                        left: 15,
                        child: ImageIcon(
                          AssetImage('images/rssnew.png'),
                          size: 32,
                          color: Colors.lightBlue,
                        ))
                ],
              ),
            )
          ],
        ));
  }
}
