import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:verification_code/verification_code.dart';

import '/../core/functions/debug_print_extension.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/routing/app_routes.dart';
import '/../core/shared_widgets/custom_primary_button.dart';
import '/../core/theme/app_colors.dart';
import '/../core/theme/app_text_style.dart';
import '/../features/auth/presentation/controllers/bloc/auth_bloc.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({required this.email, super.key});
  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? currentCode;

  @override
  void initState() {
    super.initState();
    // ابدأ العد التنازلي بمجرد فتح الشاشة
    context.read<AuthBloc>().add(StartCountdownEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyCodeSuccessState) {
            context.pushNamed(
              AppRoutes.resetPasswordScreen,
              extra: widget.email,
            );
          }
        },
        builder: (context, state) {
          var seconds = 120;
          if (state is CountdownRunning) {
            seconds = state.seconds;
          } else if (state is CountdownInitial) {
            seconds = state.seconds;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,

                  /// Title
                  Center(
                    child: Text(
                      'Verification Code',
                      style: AppTextStyle.style20W600,
                    ),
                  ),

                  40.verticalSpace,

                  /// Verification code widget
                  VerificationCode(
                    height: 60.h,
                    style: CodeStyle.rectangle,
                    borderRadius: 12.r,
                    borderWidth: 1.w,
                    borderColor: AppColors.primaryColor,
                    maxLength: 6,
                    itemWidth: 65.w,
                    onCompleted: (String value) {
                      'Code entered: $value'.dPrint();
                      currentCode = value;
                      // يمكن إرسال الحدث هنا مباشرة أو الانتظار للضغط على الزر
                    },
                  ),

                  40.verticalSpace,

                  // Timer & Resend Logic
                  if (state is CountdownFinished)
                    GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(StartCountdownEvent());
                        // Add logic here to resend code via API if needed
                        // context.read<AuthBloc>().add(ForgotPasswordReqEvent(email: widget.email));
                      },
                      child: Text(
                        'Resend Code',
                        style: AppTextStyle.style14W400.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          decorationColor: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  else
                    Text(
                      '$seconds seconds',
                      style: AppTextStyle.style14W400.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),

                  15.verticalSpace,
                  Text(
                    'Verification code sent to:',
                    style: AppTextStyle.style14W400,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.email} ',
                          style: AppTextStyle.style14W400.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: 'please check your messages.',
                          style: AppTextStyle.style14W400,
                        ),
                      ],
                    ),
                  ),
                  40.verticalSpace,

                  /// Verify button
                  if (state is VerifyCodeLoadingState)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomPrimaryButton(
                      width: double.infinity,
                      onPressed: () {
                        if (currentCode != null && currentCode!.length == 6) {
                          context.read<AuthBloc>().add(
                            VerifyCodeReqEvent(
                              code: currentCode!,
                              email: widget.email,
                            ),
                          );
                        } else {
                          // Show snackbar: Please enter valid code
                        }
                      },
                      text: 'Verify',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
