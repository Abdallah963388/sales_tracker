import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/../core/resources/assets/app_images.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/shared_widgets/custom_primary_button.dart';
import '/../core/shared_widgets/custom_primary_textfield.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/auth/presentation/controllers/bloc/auth_bloc.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            current is LoginLoadingState ||
            current is LoginSuccessState ||
            current is LoginFailedState ||
            current is PasswordVisibilityChangedState,
        listener: (context, state) {
          if (state is LoginSuccessState) {
            context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
          } else if (state is LoginFailedState) {
            // Show error dialog/snackbar here
          }
        },
        builder: (context, state) {
          final authBloc = context.read<AuthBloc>();
          final isPasswordHidden = state is PasswordVisibilityChangedState
              ? state.isPasswordHidden
              : authBloc.isPasswordHidden;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Form(
                key: formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... (Language Button Code omitted for brevity, logic remains same)

                      /// Logo
                      Center(
                        child: Image.asset(AppImages.appLogo, height: 100.h),
                      ),
                      20.verticalSpace,

                      /// Welcome
                      Center(
                        child: Text(
                          'Welcome', // Removed .tr(context)
                          style: AppTextStyle.style20W600,
                        ),
                      ),
                      30.verticalSpace,

                      Text(
                        'Email', // Removed .tr(context)
                        style: AppTextStyle.style16W500,
                      ),
                      5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: emailController,
                        text: 'Enter your email', // Removed .tr(context)
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required'; // Removed .tr(context)
                          }
                          return null;
                        },
                      ),
                      15.verticalSpace,

                      Text(
                        'Password', // Removed .tr(context)
                        style: AppTextStyle.style16W500,
                      ),
                      5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: passwordController,
                        isPassword: isPasswordHidden,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
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
                        text: 'Enter your password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(AppRoutes.forgotPasswordScreen);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      40.verticalSpace,

                      /// Login button
                      if (state is LoginLoadingState)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      else
                        CustomPrimaryButton(
                          width: double.infinity,
                          onPressed: () {
                            context.pushNamed(AppRoutes.homeScreen);
                            // if (formKey.currentState!.validate()) {
                            //   context.read<AuthBloc>().add(
                            //     LoginReqEvent(
                            //       email: emailController.text,
                            //       password: passwordController.text,
                            //     ),
                            //   );
                            // }
                          },
                          text: 'Log In',
                        ),

                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTextStyle.style14W600,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushReplacementNamed(
                                AppRoutes.registerScreen,
                              );
                            },
                            child: Text(
                              'Create Account',
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
