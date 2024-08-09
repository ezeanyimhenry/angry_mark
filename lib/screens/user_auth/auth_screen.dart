import 'package:angry_mark/email_field.dart';
import 'package:angry_mark/forgot_password_screen.dart';
import 'package:angry_mark/password_field.dart';
import 'package:flutter/material.dart';
import 'package:kimko_auth/kimko_auth.dart';

import '../../main.dart';

import '../../mythems/theme.dart';
import 'signup_screen.dart';
import '../../widgets/animation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.textLigth,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const AnimatedImage(),
              const Text(
                'Welcome Back!',
                style: TextStyle(color: AppColors.textLigth, fontSize: 30),
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
                      EmailField(emailController: email),
                      const SizedBox(
                        height: 20,
                      ),
                      PasswordField(
                        passwordController: password,
                        onPressed: () =>
                            setState(() => _isVisible = !_isVisible),
                        isVisible: _isVisible,
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: AppColors.textLigth),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: _isVisible
                            ? ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                    signIn(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Fill the fields correctly')),
                                    );
                                  }
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (cxt) => const HomeScreen()));
                                },
                                child: const Text(
                                  'SignIn',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (cxt) => const SignupScreen()));
                        },
                        child: const Text(
                          "Don't Have a Account? SignUp",
                          style: TextStyle(color: AppColors.textLigth),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kimiko Package is down, try again')),
      );
      // setState(() {
      //   // _isVisible = false;
      // });
      var res = await kimkoAuth.signIn(
          email: email.text.trim(), password: password.text.trim());
      if (res.isSuccess) {
        res.data;
        debugPrint(res.data);
        setState(() {
          _isVisible = true;
        });
      } else {
        res.data;
        debugPrint(res.data);
        setState(() {
          _isVisible = true;
        });
      }
    } on KimikoException catch (e) {
      setState(() {
        _isVisible = true;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Kimiko ${e.error}')),
      // );
      debugPrint('Kimiko ${e.error}');
    } catch (e) {
      setState(() {
        _isVisible = true;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Kimiko $e')),
      // );
      debugPrint("Another error $e");
    }
  }
}
