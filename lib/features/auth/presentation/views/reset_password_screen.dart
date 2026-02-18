import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/shared_widgets/custom_primary_button.dart';
import '/../core/shared_widgets/custom_primary_textfield.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/auth/presentation/controllers/bloc/auth_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({required this.email, super.key});
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessState) {
            context.pushReplacementNamed(AppRoutes.loginScreen);
          }
        },
        builder: (context, state) {
          final authBloc = context.read<AuthBloc>();

          final isPasswordHidden = state is PasswordVisibilityChangedState
              ? state.isPasswordHidden
              : authBloc.isPasswordHidden;

          final isConfirmPasswordHidden =
              state is ConfirmPasswordVisibilityChangedState
              ? state.isConfirmPasswordHidden
              : authBloc.isConfirmPasswordHidden;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,

                    /// Title
                    Center(
                      child: Text(
                        'Reset Password',
                        style: AppTextStyle.style20W600,
                      ),
                    ),

                    40.verticalSpace,

                    /// Password
                    Text(
                      'New Password',
                      style: AppTextStyle.style16W500,
                    ),
                    5.verticalSpace,
                    CustomPrimaryTextfield(
                      controller: passwordController,
                      isPassword: isPasswordHidden,
                      suffix: GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(
                            TogglePasswordVisibilityEvent(),
                          );
                        },
                        child: Icon(
                          isPasswordHidden
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      text: 'Enter new password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),

                    15.verticalSpace,

                    /// Confirm password
                    Text(
                      'Confirm New Password',
                      style: AppTextStyle.style16W500,
                    ),
                    5.verticalSpace,
                    CustomPrimaryTextfield(
                      controller: confirmPasswordController,
                      isPassword: isConfirmPasswordHidden,
                      suffix: GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(
                            ToggleConfirmPasswordVisibilityEvent(),
                          );
                        },
                        child: Icon(
                          isConfirmPasswordHidden
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      text: 'Confirm new password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password is required';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    40.verticalSpace,

                    /// Confirm button
                    if (state is ResetPasswordLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomPrimaryButton(
                        width: double.infinity,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              ResetPasswordReqEvent(
                                email: widget.email,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                              ),
                            );
                          }
                        },
                        text: 'Reset Password',
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
