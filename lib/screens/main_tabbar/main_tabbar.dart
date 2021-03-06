import 'package:aerotec_flutter_app/components/left_drawer/left_drawer.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';

class MainTabbar extends StatefulWidget {
  State<StatefulWidget> createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: LeftDrawer(),
        ),
        body: HomeScreen(),
        bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: CircularNotchedRectangle(),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    child: Center(
                      child: Text(
                        'LONG LINES',
                        style: TextStyle(
                          color: Colors.white,
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
                  child: Container(
                    height: 55,
                    child: Center(
                      child: Text(
                        'MAP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner()));
              },
              child:ImageIcon(AssetImage('images/rssnew.png'),size: 32,)

          ),
        ),
      ),
    );
  }
}
