// @dart=2.9

import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:aerotec_flutter_app/screens/authentication/check_authentication.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/categories_provider.dart';
import 'providers/equipment_provider.dart';
import 'screens/main_tabbar/main_tabbar.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          print(snapshot.error);
          return SomethingWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => EquipmentProvider()),
              ChangeNotifierProvider(create: (context) => UserProvider()),
              ChangeNotifierProvider(create: (context) => CategoriesProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'AeroTec App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: CheckAuthentication(),
            ),
          );
        }

        return LoadingOverlay();
      },
    );
  }
}

class SomethingWrong extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: Text('Error!'),
          ),
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
