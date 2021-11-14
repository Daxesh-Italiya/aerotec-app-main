import 'package:aerotec_flutter_app/providers/components_provider.dart';
import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/categories_provider.dart';
import 'providers/longlines_provider.dart';
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
              ChangeNotifierProvider(create: (context) => LongLinesProvider()),
              ChangeNotifierProvider(create: (context) => ComponentsProvider()),
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
              home: MainTabbar(),
            ),
          );
        }

        return LoadingOverlay();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title;
  const MyHomePage({ required this.title });

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: MainTabbar(),
      ),
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
