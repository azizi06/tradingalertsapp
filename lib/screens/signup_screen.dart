import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stocksalertapp/helpers/design.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final emailPatternRules =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passwordPatternRules = r'^(?=.*[A-Z])(?=.*?[0-9])(?=.*?[ @#\&*~]).{8,}';

  // Fonction pour créer un compte utilisateur avec Firebase
  Future<void> _createAccount() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Mise à jour du nom de l'utilisateur (facultatif)
      await userCredential.user?.updateDisplayName(nameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Account created successfully! Welcome ${nameController.text}')),
      );

      // Redirige l'utilisateur après l'inscription
      GoRouter.of(context).go('/home'); // Redirige vers une page "home"
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
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
            Expanded(
              //width: double.infinity,
              // height: double.infinity,
              child: Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/crypto_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            SizedBox(height: 80,),
                          SizedBox(
                            height: 135,
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
                            ),
                          ),
                          Text(
                            "Signup",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Create an account and start setting alerts for trading crypto",
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Name field
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Color(0xFFB4B4B4)),
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB4B4B4)),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Email field
                          TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Color(0xFFB4B4B4)),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB4B4B4)),
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
                            style: const TextStyle(color: Color(0xFFB4B4B4)),
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB4B4B4)),
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
                              if (value == null ||
                                  !passwordRegExp.hasMatch(value)) {
                                return 'Password must have at least 8 characters, 1 uppercase letter, 1 number, and 1 special character';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Confirm Password field
                          TextFormField(
                            controller: confirmPasswordController,
                            style: const TextStyle(color: Color(0xFFB4B4B4)),
                            obscureText: !_confirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB4B4B4)),
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
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          // Sign Up button
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _createAccount();
                                }
                              },
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: design.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Login navigation button
                          Center(
                            child: TextButton(
                              onPressed: () {
                                GoRouter.of(context).go('/login');
                              },
                              child: Text(
                                "Already have an account? Login",
                                style: TextStyle(color: Colors.blue[400]),
                              ),
                            ),
                          ),
                            
                        SizedBox(height: 50,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
