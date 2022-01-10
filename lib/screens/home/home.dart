import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/equipment_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
import 'package:aerotec_flutter_app/providers/equipment_provider.dart';
import 'package:aerotec_flutter_app/screens/equipment/equipment_card.dart';
import 'package:aerotec_flutter_app/screens/equipment/equipment_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSearch = false;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void initState() {
    super.initState();

    EquipmentProvider equipmentProvider = Provider.of<EquipmentProvider>(context, listen: false);
    CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        equipmentProvider.subData();
        categoriesProvider.subData();
      },
    );
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
    return Container(
      child: CustomScrollView(
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
                  style: GoogleFonts.benchNine(fontSize: 38, color: AppTheme.appBarFont)),
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
                    // Search --------------------------------------------------------

                    Expanded(
                      child: AnimatedCrossFade(
                        firstChild: Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('  Components',
                                  style: TextStyle(fontSize: 18, color: Colors.black)),
                              RoundIconButton(
                                icon: Icons.search,
                                size: 26,
                                onTap: () {
                                  setState(() {
                                    _showSearch = true;
                                    if (_showSearch) {
                                      _focusNode.requestFocus();
                                    } else {
                                      _focusNode.unfocus();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        )),
                        secondChild: Expanded(
                          child: Container(
                            height: 45,
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) {
                                // Search
                                /*Provider.of<EquipmentProvider>(context, listen: false)
                                    .changeSearchString(value);*/
                              },
                              autofocus: false,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                                  fillColor: Colors.white,
                                  prefixIcon: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: RoundIconButton(
                                        icon: Icons.search,
                                        size: 20,
                                        onTap: () {
                                          setState(() {
                                            _showSearch = false;
                                            FocusScope.of(context).requestFocus(FocusNode());
                                          });
                                        },
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFB6B6B6)),
                                      borderRadius: BorderRadius.circular(1000)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFB6B6B6)),
                                      borderRadius: BorderRadius.circular(1000))),
                            ),
                          ),
                        ),
                        crossFadeState:
                            !_showSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                        sizeCurve: Curves.easeInOutExpo,
                      ),
                    ),

                    // Add --------------------------------------------------------
                    RoundIconButton(
                      icon: Icons.add_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EquipmentForm(equipment: null, formType: 'new'),
                          ),
                        );
                      },
                    ),
                  ],
                )),
          ),
          Consumer<EquipmentProvider>(
            builder: (context, provider, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    GroupEquipment groupEquipment = provider.groupEquipments[index];

                    return Container(
                      color: Colors.grey[300],
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          textColor: Colors.black,
                          iconColor: Colors.black,
                          title: Text(groupEquipment.categoryName),
                          children: List.generate(groupEquipment.equipmentList.length, (i) {
                            groupEquipment.equipmentList
                                .sort((s1, s2) => s1.fields['name'].compareTo(s2.fields['name']));
                            return EquipmentCard(
                                equipment: groupEquipment.equipmentList[i], index: i);
                          }),
                        ),
                      ),
                    );
                  },
                  childCount: provider.groupEquipments.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({this.icon, this.onTap, this.size = 26});

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
