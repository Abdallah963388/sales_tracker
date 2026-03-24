import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/services/input_formatters.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_button.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sales_tracker/features/representative/data/model/single_rep_model.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_states.dart';

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
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.rep == null ? 'إضافة مندوب' : 'تعديل المندوب',
        canBack: true,
      ),
      body: BlocListener<RepCubit, RepState>(
        listener: (context, state) {
          if ((state.status == RepStatus.addSuccess ||
                  state.status == RepStatus.updateSuccess) &&
              state.message != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
              if (context.read<AdminHomeCubit>() != null) {
                await context.read<AdminHomeCubit>().fetchAdminHome();
              }
              context.pop(true);
            });
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
                      title: 'اسم المندوب',
                      controller: cubit.nameController,
                      validator: (v) => v!.isEmpty ? 'ادخل الاسم' : null,
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      inputFormatters: [AppInputFormatters.email],
                      keyboardType: TextInputType.emailAddress,
                      title: 'البريد الإلكتروني',
                      controller: cubit.emailController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'ادخل البريد الإلكتروني';
                        }

                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );

                        if (!emailRegex.hasMatch(v)) {
                          return 'ادخل بريد إلكتروني صحيح';
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
                      title: 'رقم الهاتف',
                      controller: cubit.phoneController,
                      validator: (v) => v!.isEmpty ? 'ادخل رقم الهاتف' : null,
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      title: 'كلمة المرور',
                      controller: cubit.passwordController,
                      isPassword: true,
                      obscureText: isPasswordHidden,
                      onTogglePassword: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                    16.verticalSpace,
                    CustomPrimaryTextfield(
                      title: 'تأكيد كلمة المرور',
                      controller: cubit.passwordConfirmationController,
                      isPassword: true,
                      obscureText: isConfirmPasswordHidden,
                      onTogglePassword: () {
                        setState(() {
                          isConfirmPasswordHidden = !isConfirmPasswordHidden;
                        });
                      },
                    ),
                    16.verticalSpace,
                    CustomPrimaryButton(
                      text: widget.rep == null
                          ? 'إضافة المندوب'
                          : 'تعديل المندوب',
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
