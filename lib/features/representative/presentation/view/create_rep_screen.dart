import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/services/input_formatters.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sit/features/representative/data/model/single_rep_model.dart';
import 'package:sit/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sit/features/representative/presentation/controller/rep_states.dart';

class AddRepScreen extends StatefulWidget {
  const AddRepScreen({super.key, this.rep});
  final SingleRepData? rep;

  @override
  State<AddRepScreen> createState() => _AddRepScreenState();
}

class _AddRepScreenState extends State<AddRepScreen> {
  late final RepCubit cubit;
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  @override
  void initState() {
    super.initState();
    cubit = context.read<RepCubit>();
    if (widget.rep != null) {
      final rep = widget.rep!;
      cubit.nameController.text = rep.name ?? '';
      cubit.emailController.text = rep.email ?? '';
      cubit.phoneController.text = rep.phone ?? '';
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    if (mounted) cubit.resetForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.rep == null ? s.addRep : s.editRep,
        canBack: true,
      ),
      body: BlocListener<RepCubit, RepState>(
        listener: (context, state) async {
          if ((state.status == RepStatus.addSuccess ||
                  state.status == RepStatus.updateSuccess) &&
              state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
            await context.read<AdminHomeCubit>().fetchAdminHome();
            context.pop(true);
          }

          if (state.status == RepStatus.failure && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Card(
              color: AppColors.whiteColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    CustomPrimaryTextfield(
                      inputFormatters: [AppInputFormatters.name],
                      keyboardType: TextInputType.name,
                      title: s.repName,
                      controller: cubit.nameController,
                      validator: (v) => v!.isEmpty ? s.enterName : null,
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      inputFormatters: [AppInputFormatters.email],
                      keyboardType: TextInputType.emailAddress,
                      title: s.email,
                      controller: cubit.emailController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return s.enterEmail;
                        }

                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );

                        if (!emailRegex.hasMatch(v)) {
                          return s.enterCorrectEmail;
                        }

                        return null;
                      },
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      inputFormatters: [
                        AppInputFormatters.phone,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      keyboardType: TextInputType.phone,
                      title: s.phone,
                      controller: cubit.phoneController,
                      validator: (v) => v!.isEmpty ? s.enterPhone : null,
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      title: s.password,
                      controller: cubit.passwordController,
                      isPassword: true,
                      obscureText: isPasswordHidden,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }

                        if (value.length < 8) {
                          return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                        }

                        return null;
                      },
                      onTogglePassword: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      title: s.confirmPassword,
                      controller: cubit.passwordConfirmationController,
                      isPassword: true,
                      obscureText: isConfirmPasswordHidden,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }

                        if (value != cubit.passwordController.text) {
                          return 'كلمة المرور لا تتطابق مع كلمة المرور الأصلية';
                        }

                        return null;
                      },
                      onTogglePassword: () {
                        setState(() {
                          isConfirmPasswordHidden = !isConfirmPasswordHidden;
                        });
                      },
                    ),
                    16.verticalSpace,
                    CustomPrimaryButton(
                      text: widget.rep == null ? s.addRep : s.editRep,
                      width: double.infinity,
                      height: 50.h,
                      icon: Icons.save,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        if (widget.rep == null) {
                          cubit.addRep();
                        } else {
                          cubit.updateRep(widget.rep!.id!);
                        }
                      },
                    ),
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
