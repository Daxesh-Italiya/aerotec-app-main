import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/longlines_provider.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines_details.dart';
import 'package:aerotec_flutter_app/widgets/loading_overlay_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LongLinesScreen extends StatefulWidget {
  _LongLinesScreen createState() => _LongLinesScreen();
}

class _LongLinesScreen extends State<LongLinesScreen> {
  late LongLinesProvider longLinesProvider;
  final bool test = true;

  void initState() {
    super.initState();
    longLinesProvider = Provider.of<LongLinesProvider>(context, listen: false);
    Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        longLinesProvider.subData();
      },
    );
  }

  Widget build(BuildContext context) {
    LongLinesProvider longLinesProvider =
        Provider.of<LongLinesProvider>(context);
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.grey[300],
              child: Text(
                'Longlines / Beacons',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: longLinesProvider.longLinesProvider.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 20, thickness: 2, indent: 1),
                itemBuilder: (_, int index) {
                  final LongLinesModel longline =
                      longLinesProvider.longLinesProvider[index];
                  return LongLineCard(longline: longline);
                },
              ),
            ),
          ],
        ),
        if (longLinesProvider.isLoading) LoadingOverlay()
      ]),
    );
  }
}

class LongLineCard extends StatelessWidget {
  final LongLinesModel longline;

  const LongLineCard({Key? key, required this.longline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> filename = longline.imagePath.split('.');
    String imageUrl = filename[0];

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 0.7))),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, _, __) =>
                      LongLinesDetails(id: this.longline.id)));
        },
        child: ListTile(
          leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey,
              ),
              child: ClipOval(
                  child: longline.imagePath.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              longline.type,
                              style: TextStyle(
                                  height: 1, fontSize: 11, color: Colors.white),
                            ),
                            Text(
                              longline.length,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            Text('${longline.safeWorkingLoad}#',
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 11,
                                    color: Colors.white))
                          ],
                        )
                      : Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/longlines%2F${imageUrl.toString()}_200x200.jpeg?alt=media',
                          fit: BoxFit.cover,
                          width: 55,
                          height: 55))),
          title: Text('${longline.name}'),
          subtitle: Text(
              '${longline.length} ${longline.type} ${longline.safeWorkingLoad}#'),
          trailing: Icon(Icons.navigate_next_sharp),
        ),
      ),
    );
  }
}

// https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/longlines%2F

// ?alt=media&token
