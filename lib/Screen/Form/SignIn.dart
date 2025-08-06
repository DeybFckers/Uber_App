import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/Screen/Form/SignUp.dart';
import 'package:uber_app/Services/GoogleAuth.dart';
import 'package:uber_app/Services/auth_service.dart';
import 'package:uber_app/widget/AuthField.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => SignIn()
  );
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _secureText = true;
  bool circular = false;
  AuthService authService = AuthService();
  GoogleAuth authGoogle = GoogleAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // This Spacer ensures that the form is pushed toward the center
                  Spacer(flex: 2),
                  // Form section
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          AuthField(
                            labelText: 'Email',
                            controller: emailController,
                          ),
                          SizedBox(height: 10),
                          AuthField(
                            labelText: 'Password',
                            controller: passwordController,
                            isPasswordText: _secureText,
                            icon: Icons.key,
                            suffixIcon: passwordController.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(
                                _secureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: (){
                                setState(() {
                                  _secureText = !_secureText;
                                });
                              },
                            )
                                : null
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                circular = true;
                              });
                              if(formKey.currentState!.validate()){
                                try{
                                  authService.loginAccount(
                                    email: emailController.text,
                                    password: passwordController.text
                                  );
                                }catch (e){
                                  setState(() {
                                    circular = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              minimumSize: Size(
                                MediaQuery.of(context).size.width * 1,
                                55,
                              ),
                            ),
                            child: circular ? CircularProgressIndicator() :
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "OR",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              final userCredential = await authGoogle.googleSignIn(context);

                              final user = userCredential?.user;
                              if(user != null){

                                final userRef = firebaseStore
                                    .collection('users')
                                    .doc(user.uid);
                                final doc = await userRef.get();

                                if(!doc.exists){
                                  await userRef.set({
                                    'Name': user.displayName ?? '',
                                    'Email': user.email??'',
                                    'Photo': user.photoURL?? '',
                                    'createdAt': DateTime.now()
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.greenAccent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/google.svg',
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Sign In with Google',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context, SignUp.route()
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          minimumSize: Size(MediaQuery.of(context).size.width * 1,
                            55
                          ),
                          side: BorderSide(color: Colors.greenAccent, width: 2),
                        ),
                        child: Text(
                          'Create new account',
                          style: TextStyle(color: Colors.white),
                        )
                      ),
                    )
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
