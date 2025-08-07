import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  Settings({super.key, required this.uid, required this.name, required this.email, required this.photoUrl});

  final firebaseStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Settings',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firebaseStore
        .collection('users')
        .doc(uid)
        .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("User data not found"));
            }

            var userData = snapshot.data!;
            var name = userData['Name'];
            var photoUrl = userData['Photo'];

            return SettingsUI(photoUrl: photoUrl, name: name);
          }
      )
    );
  }
}

class SettingsUI extends StatelessWidget{

  final String name;
  final String photoUrl;

  const SettingsUI({super.key, required this.photoUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    SizedBox(height: 10),
                    Text('$name',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    )
                  ],
                )
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(bottom: 10, top:10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: double.infinity,
                        child: Text('Change Name',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: double.infinity,
                        child: Text('Change Email',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: double.infinity,
                        child: Text('Change Password',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    InkWell(
                        onTap: (){

                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('LOGOUT',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.red
                                    )
                                ),
                              ),
                              Icon(Icons.logout),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
