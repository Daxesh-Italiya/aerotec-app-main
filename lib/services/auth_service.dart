import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }
}