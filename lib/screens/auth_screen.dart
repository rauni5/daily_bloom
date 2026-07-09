import 'package:daily_bloom/screens/root.dart';
import 'package:daily_bloom/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootShell()),
      );
    } else {
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
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Icon(Icons.spa_rounded, size: 80.sp, color: Colors.green),

                  SizedBox(height: 15.h),

                  Text(
                    "Daily Bloom",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    "Find inspiration every day.",
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                  ),

                  SizedBox(height: 35.h),

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

                        SizedBox(height: 18.h),
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

                  SizedBox(height: 18.h),

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
                        SizedBox(height: 18.h),

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

                  SizedBox(height: 30.h),

                  PrimaryButton(
                    title: isLogin ? "Login" : "Create Account",
                    onPressed: submit,
                  ),

                  SizedBox(height: 20.h),

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
    );
  }
}
