import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:aerotec_flutter_app/screens/authentication/login.dart';
import 'package:aerotec_flutter_app/screens/main_tabbar/main_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CheckAuthentication extends StatefulWidget {
  @override
  _CheckAuthenticationState createState() => _CheckAuthenticationState();
}

class _CheckAuthenticationState extends State<CheckAuthentication> {
  bool signedIn = false;
  late UserProvider userProvider;

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    checkAuth();
    super.initState();
  }

  checkAuth() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() => signedIn = false);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print('User is signed in!');
        userProvider.subUser(user.email!);
        setState(() => signedIn = true);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainTabbar()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!signedIn) {
      return LoginScreen();
    }
    if (signedIn) {
      return MainTabbar();
    }
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
