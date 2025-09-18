import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

import '../../../core/utils/validators.dart';

import '../../../core/theme/app_theme.dart';

class LoginForm extends GetView<AuthController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Credentials',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          // Employee ID Field

          TextFormField(
            controller: controller.loginEmployeeIdController,
            decoration: const InputDecoration(
              labelText: 'Employee ID',
              hintText: 'Enter your employee ID',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            validator: Validators.validateEmployeeId,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Password Field

          Obx(() => TextFormField(
                controller: controller.loginPasswordController,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                validator: Validators.validatePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.login(),
              )),

          // Forgot Password

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.snackbar(
                  'Info',
                  'Please contact your administrator',
                  snackPosition: SnackPosition.TOP,
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Login Button

          Obx(() => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),
        ],
      ),
    );
  }
}
