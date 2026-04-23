import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/features/sales_features/profile/presentation/controller/profile_cubit.dart';
import 'package:sit/features/sales_features/profile/presentation/controller/profile_states.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          Navigator.pop(context);
        }

        if (state is ProfileUpdateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: LoadingWidget()),
          );
        }

        return Scaffold(
          appBar: const CustomAppBar(title: 'تعديل البروفايل'),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomPrimaryTextfield(
                    title: 'الاسم',
                    controller: cubit.nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل الاسم';
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,

                  CustomPrimaryTextfield(
                    title: 'البريد الإلكتروني',
                    controller: cubit.emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل البريد الالكتروني';
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,

                  CustomPrimaryTextfield(
                    title: 'رقم الهاتف',
                    controller: cubit.phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل رقم الهاتف';
                      }
                      return null;
                    },
                  ),

                  30.verticalSpace,

                  CustomPrimaryButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.updateProfile();
                      }
                    },
                    text: 'حفظ التعديل',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
