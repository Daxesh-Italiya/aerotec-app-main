import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Container(child: Text()));
//   }
// }

// class GetName extends StatelessWidget {
//   final String documentId;
//
//   GetName(this.documentId);
//
//   @override
//   Widget build(BuildContext context) {
//
//     CollectionReference longlines = FirebaseFirestore.instance.collection('longlines');
//     return FutureBuilder<DocumentSnapshot>(
//       future: longlines.doc('0xqbobXq1AiYekJhqptp');
//     )
//   }
// }

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
