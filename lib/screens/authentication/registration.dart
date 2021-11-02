import 'package:aerotec_flutter_app/components/background.dart';
import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:aerotec_flutter_app/screens/main_tabbar/main_tabbar.dart';
import 'package:provider/provider.dart';
import 'invalid_registration.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  String email = '';
  String password = '';
  String passwordConfirm = '';
  String message = '';
  bool isLoading = false;
  bool signUpError = false;

   @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  Future checkUser(String email) async {
    DocumentReference user = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot snapshot = await user.get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  void signUp() async {
    setState(() => isLoading = true);
    bool userExists = await checkUser(email);
    
    if (userExists) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim().toLowerCase(), 
          password: password.trim()
        );
        userProvider.subUser(email);
        setState(() => isLoading = false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainTabbar()));

      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false; signUpError = true; message = e.code;
        });
      }
    } else if (!userExists) {
      setState(() => isLoading = false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => InvalidRegistration()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(Icons.chevron_left),
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(height: size.height * .05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Registration',
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          if (signUpError)
                            Text(message, style: TextStyle(color: Colors.red)),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          TextFieldWidget(
                            textCapitalization: TextCapitalization.none,
                            obscureText: false,
                            initialValue: email,
                            onChanged: (val) => setState(() => email = val),
                            validator: (val) =>
                                !isEmail(val) ? 'Invalid Email' : null,
                            labelText: 'Email Address',
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          TextFieldWidget(
                            textCapitalization: TextCapitalization.none,
                            obscureText: true,
                            initialValue: email,
                            onChanged: (val) => setState(() => password = val),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            labelText: 'Password',
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          TextFieldWidget(
                            textCapitalization: TextCapitalization.none,
                            obscureText: true,
                            initialValue: email,
                            onChanged: (val) =>
                                setState(() => passwordConfirm = val),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (val != password) {
                                return 'Password doesnt not match';
                              }
                              return null;
                            },
                            labelText: 'Confirm Password',
                          ),
                          SizedBox(height: size.height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      signUp();
                                    }
                                  }, //=> login()},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    child: Text('Sign Up'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading) LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}
