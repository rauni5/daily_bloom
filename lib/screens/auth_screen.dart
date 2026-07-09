import 'package:daily_bloom/screens/root.dart';
import 'package:daily_bloom/state/app_state.dart';
import 'package:daily_bloom/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/responsive.dart';
import '../widgets/primary_button.dart';
import 'preference_picker_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    final app = context.read<AppState>();

    if (isLogin) {
      final fallbackName = emailController.text.split("@").first;
      app.login(fallbackName);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootShell()),
      );
    } else {
      app.login(nameController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PreferencePickerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ResponsiveCenter(
              maxWidth: 420,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Icon(Icons.spa_rounded, size: 80, color: Colors.green),

                    SizedBox(height: 15),

                    Text(
                      "Daily Bloom",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Find inspiration every day.",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),

                    SizedBox(height: 35),

                    if (!isLogin)
                      Column(
                        children: [
                          CustomTextField(
                            label: "Full Name",
                            controller: nameController,
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your name";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 18),
                        ],
                      ),

                    CustomTextField(
                      label: "Email",
                      controller: emailController,
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter email";
                        }

                        if (!value.contains("@")) {
                          return "Invalid email";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 18),

                    CustomTextField(
                      label: "Password",
                      controller: passwordController,
                      obscure: true,
                      icon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }

                        return null;
                      },
                    ),

                    if (!isLogin)
                      Column(
                        children: [
                          SizedBox(height: 18),

                          CustomTextField(
                            label: "Confirm Password",
                            controller: confirmPasswordController,
                            obscure: true,
                            icon: Icons.lock_outline,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return "Passwords don't match";
                              }

                              return null;
                            },
                          ),
                        ],
                      ),

                    SizedBox(height: 30),

                    PrimaryButton(
                      title: isLogin ? "Login" : "Create Account",
                      onPressed: submit,
                    ),

                    SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
