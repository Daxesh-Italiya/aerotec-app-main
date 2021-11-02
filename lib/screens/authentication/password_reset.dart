import 'package:aerotec_flutter_app/components/background.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  final _formKey = GlobalKey<FormState>();
  bool error = false;
  bool isLoading = false;
  String message = '';
  String email = '';

  void resetPassword(String email) async {
    setState(() => isLoading = true);

    try {
      
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() => isLoading = false);
      Navigator.pop(context);

    } on FirebaseAuthException catch(e) {
      
      setState(() {
        isLoading = false; error = true; message = e.code;
      });
      
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
                    SizedBox(height: size.height * .2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          if (error)
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      resetPassword(email);
                                    }
                                  }, //=> login()},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15.0),
                                    child: Text('Reset Password'),
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