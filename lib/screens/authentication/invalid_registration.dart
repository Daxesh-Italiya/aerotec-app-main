import 'package:flutter/material.dart';

class InvalidRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            AppBar(
              title: Text('Return to Registration', style: TextStyle(color: Colors.black87)),
              leading: IconButton(
                icon: Icon(Icons.chevron_left), 
                onPressed: () => Navigator.pop(context), 
                color: Colors.black87
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('This user does not exist!'),
                  Text('Please contact your Administrator for details!'),
                ],
              ),
            ),
            Expanded(child: SizedBox(), flex: 1)
          ],
        ),
      ),
    );
  }
}
