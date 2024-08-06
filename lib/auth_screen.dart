import 'package:flutter/material.dart';

import 'main_screen.dart';
import 'mythems/theme.dart';
import 'screens/signup_screen.dart';
import 'widgets/animation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AnimatedImage(),
            const Text(
              'Welcome Back!',
              style: TextStyle(color: AppColors.textDark, fontSize: 30),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, right: 24, left: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //for Email Field
                    TextFormField(
                      controller: email,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: AppColors.textFaded),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //for password Field
                    TextFormField(
                      controller: password,

                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: AppColors.textFaded),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot password?'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (cxt) => const MainMenu()));
                        },
                        child: const Text(
                          'SignIn',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (cxt) => const SignupScreen()));
                      },
                      child: const Text("Don't Have a Account? SignUp"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
