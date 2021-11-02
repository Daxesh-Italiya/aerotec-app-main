import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/longlines_provider.dart';
import 'package:aerotec_flutter_app/screens/long_lines/inspection_checklist.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines_form.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LongLinesDetails extends StatefulWidget {
  final String id;

  const LongLinesDetails({@required required this.id});

  _LongLinesDetailsState createState() => _LongLinesDetailsState();
}

class _LongLinesDetailsState extends State<LongLinesDetails> {
  late LongLinesModel longLineInfo;
  late LongLinesProvider longLinesProvider;
  bool tile1 = false;
  bool tile2 = false;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    LongLinesProvider longLinesProvider =
        Provider.of<LongLinesProvider>(context);
    longLineInfo = longLinesProvider.longLinesProvider
        .singleWhere((element) => element.id == widget.id);

    DateFormat formatter = DateFormat('MMMM dd, yyyy');
    var inspectionDate =
        formatter.format(this.longLineInfo.inspectionDate.toDate());
    var nextInspection =
        formatter.format(this.longLineInfo.nextInspectionDate.toDate());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(
            'LONG LINE DETAIL',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Header(longLineInfo: this.longLineInfo),
                  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
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
                  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
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
                                      builder: (context) =>
                                          InpsectionChecklists()));
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
                  /*  Container(
                    color: Colors.grey[300],
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        initiallyExpanded: false,
                        onExpansionChanged: (val) {
                          setState(() => tile2 = val);
                        },
                        title: Text('Components'),
                        children: [
                          Container(
                            color: Colors.white,
                            child: ListTile(
                                tileColor: Colors.white,
                                title: Text('Component 1')),
                          ),
                          Container(
                            color: Colors.white,
                            child: ListTile(title: Text('Component 2')),
                          ),
                        ],
                      ),
                    ),
                  ),*/
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
                          SizedBox(
                              height: 200,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      37.42796133580664, -122.085749655962),
                                  zoom: 14.4746,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (longLinesProvider.isLoading) LoadingOverlay()
          ],
        ));
  }
}

class Header extends StatelessWidget {
  final LongLinesModel longLineInfo;

  const Header({Key? key, required this.longLineInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> filename = longLineInfo.imagePath.split('.');
    String imageUrl = filename[0];

    return Container(
        width: double.infinity,
        height: 250,
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
                              builder: (context) => LongLinesForm(
                                  longline: this.longLineInfo,
                                  formType: 'edit')));
                          break;
                        }
                      case 1:
                        {
                          print('Load Map');
                          break;
                        }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Modify Long Line'),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text('Find on Map'),
                      value: 1,
                    ),
                  ],
                )),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    width: 125,
                    height: 125,
                    child: ClipOval(
                        child: longLineInfo.imagePath.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    longLineInfo.type,
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    longLineInfo.length,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  Text('${longLineInfo.safeWorkingLoad}#',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 16,
                                          color: Colors.white))
                                ],
                              )
                            : Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/longlines%2F${imageUrl.toString()}_800x800.jpeg?alt=media',
                                fit: BoxFit.cover,
                                width: 125,
                                height: 125)),
                  ),
                  SizedBox(height: 15),
                  Text(
                    this.longLineInfo.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${this.longLineInfo.length} ${this.longLineInfo.type} ${this.longLineInfo.safeWorkingLoad}#',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
