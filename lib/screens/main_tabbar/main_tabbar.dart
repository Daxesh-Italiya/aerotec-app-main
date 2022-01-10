import 'package:aerotec_flutter_app/components/left_drawer/left_drawer.dart';
import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/screens/map/map.dart';
import 'package:aerotec_flutter_app/screens/scan/nfc-scanning.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';

class MainTabbar extends StatefulWidget {
  State<StatefulWidget> createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: LeftDrawer(),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(),
            Map(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: CircularNotchedRectangle(),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onItemTapped(0),
                  child: Container(
                    height: 55,
                    child: Center(
                      child: Text('COMPONENTS',
                        style: TextStyle(color: (_selectedIndex == 0) ? Colors.white : Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  top: 20,
                  right: 40,
                  bottom: 20,
                ),),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onItemTapped(1),
                  child: Container(
                    height: 55,
                    child: Center(
                      child: Text('MAP',
                        style: TextStyle(color: (_selectedIndex == 1) ? Colors.white : Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NFC_Scanning()));
            },
            child:ImageIcon(AssetImage('images/rssnew.png'),size: 32,)
          ),
        ),
      ),
    );
  }
}
