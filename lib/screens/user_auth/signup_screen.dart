import 'package:angry_mark/email_field.dart';
import 'package:angry_mark/password_field.dart';
import 'package:flutter/material.dart';

import 'auth_screen.dart';
import '../home_screen.dart';
import '../../mythems/theme.dart';
import '../../widgets/animation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: topPadding,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const AnimatedImage(),
                  const Text(
                    'Welcome to Angry MARK!',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: AppColors.cardLight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            cursorColor: AppColors.textLigth,
                            style: const TextStyle(
                              color: AppColors.textLigth,
                              fontSize: 15.0,
                            ),
                            controller: name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: AppColors.iconLight,
                              ),
                              label: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    color: AppColors.textLigth,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          EmailField(emailController: email),
                          const SizedBox(height: 20),
                          PasswordField(
                            passwordController: password,
                            onPressed: () =>
                                setState(() => _isVisible = !_isVisible),
                            isVisible: _isVisible,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Processing Data'),
                                    ),
                                  );
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (cxt) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'SignUp',
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
                                  builder: (cxt) => const AuthScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Already Have an Account? SignIn",
                              style: TextStyle(color: AppColors.textLigth),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
