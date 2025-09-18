import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

import '../../../core/utils/validators.dart';

import '../../../core/theme/app_theme.dart';

class SignupForm extends GetView<AuthController> {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          // Name Field

          TextFormField(
            controller: controller.signupNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: Validators.validateName,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Employee ID Field

          TextFormField(
            controller: controller.signupEmployeeIdController,
            decoration: const InputDecoration(
              labelText: 'Employee ID',
              hintText: 'Enter your employee ID',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            validator: Validators.validateEmployeeId,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Department Field

          TextFormField(
            controller: controller.signupDepartmentController,
            decoration: const InputDecoration(
              labelText: 'Department',
              hintText: 'Enter your department',
              prefixIcon: Icon(Icons.business_outlined),
            ),
            validator: Validators.validateName,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Password Field

          Obx(() => TextFormField(
                controller: controller.signupPasswordController,
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
                textInputAction: TextInputAction.next,
              )),

          const SizedBox(height: 16),

          // Confirm Password Field

          Obx(() => TextFormField(
                controller: controller.signupConfirmPasswordController,
                obscureText: !controller.isConfirmPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
                validator: (value) => Validators.validateConfirmPassword(
                  controller.signupPasswordController.text,
                  value,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.signup(),
              )),

          const SizedBox(height: 32),

          // Signup Button

          Obx(() => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.signup,
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
                          'Sign Up',
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
