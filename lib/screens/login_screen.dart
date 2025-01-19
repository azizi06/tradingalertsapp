import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/helpers/routes.dart';

// password : Tlemcen@1234
// email : tlemcen@algeria.com
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController =
      TextEditingController(text: "tlemcen@algeria.com");
  final TextEditingController passwordController =
      TextEditingController(text: "Tlemcen@1234");

  bool _passwordVisible = false;

  final emailPatternRules =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passwordPatternRules = r'^(?=.*[A-Z])(?=.*?[0-9])(?=.*?[ @#\&*~]).{8,}';

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      context.goNamed(Routes.routeMyHomePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Design design = Design(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/crypto_background.jpg', // Assurez-vous que l'image existe dans le dossier assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      height: 210,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trading Alerts",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Stay Up-to-Date",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ],
                      )),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Login,and start setting alerts for trading crypto",
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Email field
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(
                              color: Color(0xFFB4B4B4)), // White-grey color
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: const TextStyle(
                                color: Color(0xFFB4B4B4)), // White-grey color
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                          ),
                          validator: (value) {
                            final emailRegExp = RegExp(emailPatternRules);
                            if (value == null || !emailRegExp.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Password field
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(
                              color: Color(0xFFB4B4B4)), // White-grey color
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(
                                color: Color(0xFFB4B4B4)), // White-grey color
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            final passwordRegExp = RegExp(passwordPatternRules);
                            if (value == null //|| !passwordRegExp.hasMatch(value)
                               ) {
                              return 'Password must have at least 8 characters,\n 1 uppercase letter, 1 number, and 1 special character';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  design.primary, //Colors.blue[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print("Email: ${emailController.text}");
                                print("Password: ${passwordController.text}");

                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'email', emailController.text);
                                  print("Email Stored");

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Login successful!')),
                                  );
                                  context.goNamed(Routes.routeMyHomePage);
                                } on FirebaseAuthException catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('invalid-email or password')),
                                  );

                                  if (e.code == 'invalid-email') {
                                    print('Invalid Email');
                                  } else if (e.code == 'invalid-credential') {
                                    print('user-not-found OR Wrong Password');
                                  } else {
                                    print(
                                        'Failed to login with error code: ${e.code}, ${e.message}');
                                  }
                                }
                              }
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: design.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Signup navigation button
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Naviguer vers la page d'inscription avec GoRouter
                              GoRouter.of(context).go('/signup');
                            },
                            child: Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(color: Colors.blue[400]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 155,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
