import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/longlines_provider.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Container(child: Text()));
//   }
// }

// class GetName extends StatelessWidget {
//   final String documentId;
//
//   GetName(this.documentId);
//
//   @override
//   Widget build(BuildContext context) {
//
//     CollectionReference longlines = FirebaseFirestore.instance.collection('longlines');
//     return FutureBuilder<DocumentSnapshot>(
//       future: longlines.doc('0xqbobXq1AiYekJhqptp');
//     )
//   }
// }

class _HomeScreenState extends State<HomeScreen> {
  late LongLinesProvider longLinesProvider;

  bool _showSearch = false;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
                pinned: true,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                backgroundColor: AppTheme.primary,
                title: Text('AERTOTEC SYSTEMS',
                    style: GoogleFonts.benchNine(
                        fontSize: 38, color: AppTheme.appBarFont)),
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Image.asset(
                      "images/background.jpg",
                      height: 300,
                      // width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                    ),
                  ),
                )),
            SliverToBoxAdapter(
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      if (!_showSearch)
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Long Lines',
                              style: TextStyle(
                                  fontSize: 18, color: AppTheme.primary),
                            ),
                            RoundIconButton(
                              icon: Icons.search,
                              onTap: () {
                                setState(() {
                                  _showSearch = true;
                                });
                              },
                            ),
                          ],
                        ))
                      else
                        Expanded(
                            child: Container(
                          height: 45,
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: RoundIconButton(
                                  icon: Icons.search,
                                  onTap: () {
                                    setState(() {
                                      _showSearch = false;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(100)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(100))),
                          ),
                        )),

                      /// search

                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: ImageIcon(
                              AssetImage('images/menu.png'),
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      /// add
                      RoundIconButton(
                        icon: Icons.add_outlined,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LongLinesForm(
                                  longline: null, formType: 'new'),
                            ),
                          );
                        },
                      ),
                    ],
                  )),
            ),
            Consumer<LongLinesProvider>(
              builder: (context, provider, child) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    final LongLinesModel longline =
                        provider.longLinesProvider[index];
                    return LongLineCard(longline: longline);
                  },
                  childCount: provider.longLinesProvider.length,
                ));
              },
            )
          ],
        ),
      ],
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    Key? key,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(6),
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 26,
            color: Colors.white,
          )),
    );
  }
}
