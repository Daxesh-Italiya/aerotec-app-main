import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/screens/components/components_form.dart';
import 'package:aerotec_flutter_app/screens/long_lines/longlines_form.dart';
import 'package:flutter/material.dart';
import 'package:aerotec_flutter_app/components/left_drawer/left_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import '../platform//platform.dart';
import '../long_lines/longlines.dart';
import '../components/components.dart';

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
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(
            'AERTOTEC SYSTEMS',
            style: GoogleFonts.benchNine(
              fontSize: 38,
              color: AppTheme.appBarFont
            )
          ),
          actions: [
            if (_selectedIndex == 1)
              IconButton(
                icon: const Icon(Icons.add),
                iconSize: 30.0,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        LongLinesForm(longline: null, formType: 'new'),
                  ),
                ),
              ),
            if (_selectedIndex == 3)
              IconButton(
                icon: const Icon(Icons.add),
                iconSize: 30.0,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ComponentsForm(component: null, formType: 'new'),
                  ),
                ),
              ),
          ],
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
        ),
        drawer: Drawer(
          child: LeftDrawer(),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(),
            LongLinesScreen(),
            PlatformScreen(),
            ComponentsScreen(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 76,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              iconSize: 40,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              unselectedItemColor: Colors.blue.shade200,
              selectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  label: 'HOME',
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'LONG LINES',
                  icon: Icon(Icons.bluetooth_rounded),
                  activeIcon: Icon(Icons.bluetooth_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'PLATFORM',
                  icon: Icon(Icons.airplanemode_active),
                  activeIcon: Icon(Icons.airplanemode_active),
                ),
                BottomNavigationBarItem(
                  label: 'COMPONENTS',
                  icon: Icon(Icons.settings),
                  activeIcon: Icon(Icons.settings),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Container(
        //   height: 70.0,
        //   width: 70.0,
        //   child: FittedBox(
        //     child: FloatingActionButton(
        //       onPressed: () {
        //         // Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner()));
        //       },
        //       child: Icon(Icons.navigation, size: 30.0),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
