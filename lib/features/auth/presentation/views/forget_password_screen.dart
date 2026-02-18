import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/shared_widgets/custom_primary_button.dart';
import '/../core/shared_widgets/custom_primary_textfield.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/auth/presentation/controllers/bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccessState) {
            context.pushNamed(
              AppRoutes.verificationScreen,
              extra: emailController.text,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    16.verticalSpace,
                    Text(
                      'Email',
                      style: AppTextStyle.style16W500,
                      textAlign: TextAlign.start,
                    ),
                    12.verticalSpace,
                    CustomPrimaryTextfield(
                      controller: emailController,
                      text: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),

                    60.verticalSpace,

                    /// Confirm button
                    if (state is ForgotPasswordLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomPrimaryButton(
                        width: double.infinity,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              ForgotPasswordReqEvent(
                                email: emailController.text,
                              ),
                            );
                          }
                        },
                        text: 'Confirm',
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
