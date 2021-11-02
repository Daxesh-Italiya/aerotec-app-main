import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({@required required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          // image: DecorationImage(
          //     image: AssetImage('images/login-bkgd.png'), fit: BoxFit.fill),
       ),
      child: Stack(
        children: [
          child
        ],
      ),
    );
  }
}
