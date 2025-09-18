import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

import '../../widgets/auth/login_form.dart';

import '../../widgets/auth/signup_form.dart';

import '../../../core/theme/app_theme.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F4F3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo and title

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.train,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'KOCHI METRO RAIL LIMITED',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  'SUPERVISOR DASHBOARD',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 48),

                // Auth form container

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Tab header

                      Obx(() => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!controller.isLogin.value) {
                                        controller.toggleAuthMode();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: BoxDecoration(
                                        color: controller.isLogin.value
                                            ? AppTheme.primaryColor
                                            : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'Login',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: controller.isLogin.value
                                              ? Colors.white
                                              : AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.isLogin.value) {
                                        controller.toggleAuthMode();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: BoxDecoration(
                                        color: !controller.isLogin.value
                                            ? AppTheme.primaryColor
                                            : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'Sign Up',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: !controller.isLogin.value
                                              ? Colors.white
                                              : AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),

                      // Form content with animation

                      AnimatedBuilder(
                        animation: controller.slideAnimation,
                        builder: (context, child) {
                          return Obx(() => Transform.translate(
                                offset: Offset(
                                  controller.isLogin.value
                                      ? (1 - controller.slideAnimation.value) *
                                          -50
                                      : (1 - controller.slideAnimation.value) *
                                          50,
                                  0,
                                ),
                                child: Opacity(
                                  opacity: controller.slideAnimation.value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: controller.isLogin.value
                                        ? const LoginForm()
                                        : const SignupForm(),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
