import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  const Home({super.key, required this.uid, required this.name, required this.email, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Home',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

          ),
        )
      ),
    );
  }
}
