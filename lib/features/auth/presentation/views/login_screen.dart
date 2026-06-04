import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
// import '/../core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_images.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/auth/presentation/controllers/auth_cubit.dart';

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

  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    // final isPasswordHidden = context.watch<LoginCubit>().isPasswordHidden;
    return Scaffold(
      appBar: const CustomAppBar(
        canBack: true,
      ),
      body: BlocConsumer<LoginCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            emailController.clear();
            passwordController.clear();
            context.goNamed(AppRoutes.salesMainLayoutScreen);
          }

          if (state is LoginFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final s = S.of(context)!;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... (Language Button Code omitted for brevity, logic remains same)
                      // 20.verticalSpace,

                      /// Logo
                      Center(
                        child: Image.asset(
                          AppImages.salesAppLogo,
                          width: 250.h,
                        ),
                      ),
                      // 20.verticalSpace,

                      /// Welcome
                      Center(
                        child: Text(
                          s.welcome, // Removed .tr(context)
                          style: AppTextStyle.style20W600,
                        ),
                      ),
                      30.verticalSpace,

                      // Text(
                      //   'Email', // Removed .tr(context)
                      //   style: AppTextStyle.style16W500,
                      // ),
                      // 5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: emailController,
                        title: s.email, // Removed .tr(context)
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return s.required; // Removed .tr(context)
                          }
                          return null;
                        },
                      ),
                      15.verticalSpace,

                      // Text(
                      //   'Password', // Removed .tr(context)
                      //   style: AppTextStyle.style16W500,
                      // ),
                      // 5.verticalSpace,
                      CustomPrimaryTextfield(
                        controller: passwordController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        obscureText: isPasswordHidden,
                        onTogglePassword: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        title: s.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return s.required;
                          }
                          return null;
                        },
                      ),

                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       context.pushNamed(AppRoutes.forgotPasswordScreen);
                      //     },
                      //     child: const Text(
                      //       'هل نسيت كلمة المرور؟',
                      //       style: TextStyle(
                      //         color: AppColors.secondaryColor,
                      //         decoration: TextDecoration.underline,
                      //         decorationColor: AppColors.secondaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      80.verticalSpace,
                      if (state is LoginLoadingState ||
                          state is LoginSuccessState)
                        const Center(child: LoadingWidget())
                      else
                        CustomPrimaryButton(
                          width: double.infinity,
                          onPressed: state is LoginLoadingState
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<LoginCubit>().login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                          text: s.login,
                        ),

                      20.verticalSpace,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'ليس لديك اي حساب؟',
                      //       style: AppTextStyle.style14W600,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         context.pushReplacementNamed(
                      //           AppRoutes.registerScreen,
                      //         );
                      //       },
                      //       child: Text(
                      //         'إنشاء حساب',
                      //         style: AppTextStyle.style14W600.copyWith(
                      //           color: AppColors.primaryColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
