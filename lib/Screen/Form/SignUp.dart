import 'package:flutter/material.dart';
import 'package:uber_app/Screen/Form/SignIn.dart';
import 'package:uber_app/Services/GoogleAuth.dart';
import 'package:uber_app/Services/auth_service.dart';
import 'package:uber_app/widget/AuthField.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../utils/PasswordLogic.dart';

class SignUp extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => SignUp()
  );
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;
  PasswordStrength? _passwordStrength;
  bool _showPasswordInstructions = false;
  bool _secureText = true;
  bool circular = false;
  GoogleAuth authGoogle = GoogleAuth();
  AuthService authService = AuthService();

  void dispose(){
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void initState(){
    super.initState();
    passwordController.addListener((){
      final text = passwordController.text;
      final strength = PasswordStrength.calculate(text: passwordController.text);
      setState(() {
        _passwordStrength = strength;
        _showPasswordInstructions = text.isNotEmpty;
      });
    });
  }

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
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AuthField(
                                  labelText: 'First Name',
                                  controller: firstNameController,
                                  icon: Icons.person
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: AuthField(
                                  labelText: 'Last Name',
                                  controller: lastNameController,
                                  icon: Icons.person
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          AuthField(
                            labelText: 'Email',
                            controller: emailController,
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Email";
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if(!emailRegex.hasMatch(value)){
                                return "Enter a valid email address";
                              }
                              return null;
                            },
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
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Password";
                              }
                              if (value.length < 8) {
                                return "Password must be at least 8 characters long";
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return "Password must contain at least one uppercase letter";
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return "Password must contain at least one number";
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                return "Password must include a special character";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          AuthField(
                            labelText: 'Confirm Password',
                            controller: confirmPasswordController,
                            isPasswordText: _secureText,
                            icon: Icons.key,
                            suffixIcon: passwordController.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(_secureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              ),
                              onPressed: (){
                                setState(() {
                                  _secureText =! _secureText;
                                });
                              },
                            )
                                : null
                          ),
                          if (_showPasswordInstructions) ...[
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: PasswordStrength.buildInstructionChecklist(passwordController.text),
                            ),
                          ],
                          if (_passwordStrength != null) ... [
                            const SizedBox(height:10),
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds:300),
                                  height: 8,
                                  width: 300 * _passwordStrength!.widthPerc,
                                  decoration: BoxDecoration(
                                    color: _passwordStrength!.statusColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width:2),
                                _passwordStrength!.statusWidget ?? const SizedBox(),
                              ],
                            )
                          ],
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                circular = true;
                              });
                              if(passwordController.text == confirmPasswordController.text){
                                if(formKey.currentState!.validate()){
                                  try{
                                    authService.registerAccount(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                    );
                                  }catch (e){
                                    setState(() {
                                      circular = false;
                                    });
                                  }
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Passwords do not match')),
                                );
                                setState(() {
                                  circular = false;
                                });
                                return;
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
                              'Sign Up',
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
                                    'Sign Up with Google',
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
                  Spacer(flex: 2),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, SignIn.route()
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
