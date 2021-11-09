import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:aerotec_flutter_app/screens/authentication/password_reset.dart';
import 'package:aerotec_flutter_app/screens/authentication/registration.dart';
import 'package:aerotec_flutter_app/screens/main_tabbar/main_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  bool signInError = false;
  bool isLoading = false;
  String message = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  void login() async {
    setState(() => isLoading = true);
    try {
      
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      
      // User Exists! Subscribe to User
      userProvider.subUser(email);
      setState(() => isLoading = false);
      Future.delayed(
      const Duration(milliseconds: 900),
      () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainTabbar()));
      },
    );
      

    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false; signInError = true; message = e.code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * .2,
                    ),
                    Text('LOGIN', style: TextStyle(fontSize: 24.0)),
                    SizedBox(
                      height: size.height * .03,
                    ),
                    if (signInError)
                      Text(message, style: TextStyle(color: Colors.red)),
                    SizedBox(
                      height: size.height * .03,
                    ),
                    TextFieldWidget(
                      textCapitalization: TextCapitalization.none,
                      obscureText: false,
                      initialValue: email,
                      onChanged: (val) => setState(() => email = val),
                      validator: (val) => !isEmail(val) ? 'Invalid Email' : null,
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
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PasswordReset())),
                            child: Text('Forgot Password? Click Here'),
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              }
                            }, //=> login()},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15.0),
                              child: Text('Login'),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: size.height * .03),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.black),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen())),
                              child: Text('Register a New User'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading) LoadingOverlay(),
        ],
      ),
    );
  }
}
