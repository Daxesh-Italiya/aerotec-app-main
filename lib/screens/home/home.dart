import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
import 'package:aerotec_flutter_app/providers/longlines_provider.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late CategoriesProvider categoriesProvider;

  bool _showSearch = false;

  void initState() {
    super.initState();
    longLinesProvider = Provider.of<LongLinesProvider>(context, listen: false);
    categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        longLinesProvider.subData();
        categoriesProvider.subData();
      },
    );

    //removeAllCategory();
  }

  removeAllCategory() async {
    //remove all categories
    var collection = FirebaseFirestore.instance.collection('categories');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
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
                      Expanded(
                        child: AnimatedCrossFade(
                          firstChild: Expanded(
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
                                size: 26,
                                onTap: () {
                                  setState(() {
                                    _showSearch = true;
                                  });
                                },
                              ),
                            ],
                          )),
                          secondChild: Expanded(
                              child: Container(
                            height: 45,
                            child: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  fillColor: Colors.white,
                                  prefixIcon: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: RoundIconButton(
                                        icon: Icons.search,
                                        size: 20,
                                        onTap: () {
                                          setState(() {
                                            _showSearch = false;
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          });
                                        },
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFB6B6B6)),
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFB6B6B6)),
                                      borderRadius:
                                          BorderRadius.circular(1000))),
                            ),
                          )),
                          crossFadeState: !_showSearch
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(seconds: 1),
                          sizeCurve: Curves.easeInOutExpo,
                        ),
                      ),

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
                    return LongLineCard(longline: longline, index: index);
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
  const RoundIconButton({Key? key, this.icon, this.onTap, this.size = 26})
      : super(key: key);

  final IconData? icon;
  final VoidCallback? onTap;
  final double size;

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
            size: size,
            color: Colors.white,
          )),
    );
  }
}
