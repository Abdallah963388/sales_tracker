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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Form(
                key: formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Center(
                        child: Text(
                          'Create Account', // Removed .tr
                          style: AppTextStyle.style20W600,
                        ),
                      ),
                      30.verticalSpace,
                      Text(
                        'Full Name',
                        style: AppTextStyle.style16W500,
                      ),
                      5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: fullNameController,
                        text: 'Enter your full name',
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      15.verticalSpace,
                      Text('Email', style: AppTextStyle.style16W500),
                      5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        text: 'Enter your email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      15.verticalSpace,
                      Text('Password', style: AppTextStyle.style16W500),
                      5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.password],
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
                        text: 'Enter password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      15.verticalSpace,
                      Text(
                        'Confirm Password',
                        style: AppTextStyle.style16W500,
                      ),
                      5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: confirmPasswordController,
                        isPassword: isConfirmPasswordHidden,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
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
                        text: 'Confirm password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Password and Confirm Password do not match';
                          }
                          return null;
                        },
                      ),
                      30.verticalSpace,
                      if (state is RegisterLoadingState)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      else
                        CustomPrimaryButton(
                          width: double.infinity,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                RegisterReqEvent(
                                  fullName: fullNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                ),
                              );
                            }
                          },
                          text: 'Register',
                        ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTextStyle.style14W600,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushReplacementNamed(
                                AppRoutes.loginScreen,
                              );
                            },
                            child: Text(
                              'Log In',
                              style: AppTextStyle.style14W600.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
