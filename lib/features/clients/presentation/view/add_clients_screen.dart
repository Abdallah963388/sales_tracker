import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:sales_tracker/core/functions/config_loading.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/services/input_formatters.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_button.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_state.dart';
import 'package:sales_tracker/features/home/presentation/controller/rep_home_cubit.dart';

// ignore: must_be_immutable
class AddClientsScreen extends StatefulWidget {
  const AddClientsScreen({super.key, this.client});
  final Client? client;

  @override
  State<AddClientsScreen> createState() => _AddClientsScreenState();
}

class _AddClientsScreenState extends State<AddClientsScreen> {
  bool isVisible = true;
  String? locationText;

  Future<void> _confirmAndGetLocation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد'),
          content: const Text('هل تريد تحديد موقعك الحالي؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'إلغاء',
                style: AppTextStyle.style12W500.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await _getLocation();
  }

  Future<void> _getLocation() async {
    showLoading();
    final location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();

    final cubit = context.read<ClientCubit>()
      ..latitude = locationData.latitude
      ..longitude = locationData.longitude;
    cubit.locationController.text =
        ' ${locationData.latitude},  ${locationData.longitude}';

    setState(() {
      locationText = cubit.locationController.text;
    });

    if (mounted) {
      hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد الموقع بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  late final ClientCubit cubit;
  @override
  void initState() {
    super.initState();

    cubit = context.read<ClientCubit>();

    if (widget.client != null) {
      // final client = widget.client!;

      cubit.clientNameController.text = widget.client!.clientName ?? '';
      cubit.businessNameController.text = widget.client!.businessName ?? '';
      cubit.businessDetailsController.text =
          widget.client!.businessDetails ?? '';
      cubit.regionController.text = widget.client!.region ?? '';
      cubit.phoneController.text = widget.client!.phone ?? '';
      cubit.emailController.text = widget.client!.email ?? '';
      cubit.locationController.text = widget.client!.location ?? '';

      cubit.latitude = widget.client!.latitude;
      cubit.longitude = widget.client!.longitude;
      locationText = cubit.locationController.text;
    }
  }

  @override
  void dispose() {
    if (mounted) cubit.resetForm();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientCubit, ClientState>(
      listener: (context, state) {
        if (state.status == ClientStatus.addSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'تمت إضافة العميل')),
            );

            await context.read<RepHomeCubit>().fetchRepHome();

            context.pop(true);
          });
        }

        if (state.status == ClientStatus.updateSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? '')),
            );

            await context.read<RepHomeCubit>().fetchRepHome();
            // await context.read<ClientCubit>().getClients();
          });
          context.pop();
          context.pop(true);
        }

        if (state.status == ClientStatus.failure && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.client == null ? 'إضافة عميل' : 'تعديل العميل',
          canBack: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('بيانات العميل', style: AppTextStyle.style14W800),
                12.verticalSpace,
                // قسم بيانات العميل
                Card(
                  color: AppColors.whiteColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.name],
                          keyboardType: TextInputType.name,
                          title: 'الاسم',
                          controller: context
                              .read<ClientCubit>()
                              .clientNameController,
                          validator: (v) => v!.isEmpty ? 'ادخل الاسم' : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.businessName],
                          keyboardType: TextInputType.text,
                          title: 'اسم المكان',
                          controller: context
                              .read<ClientCubit>()
                              .businessNameController,
                          validator: (v) =>
                              v!.isEmpty ? 'ادخل اسم المكان' : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.businessName],
                          keyboardType: TextInputType.text,
                          title: 'المنطقة',
                          controller: context
                              .read<ClientCubit>()
                              .regionController,
                          validator: (v) => v!.isEmpty ? 'ادخل المنطقة' : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.email],
                          keyboardType: TextInputType.emailAddress,
                          title: 'البريد الإلكتروني',
                          controller: context
                              .read<ClientCubit>()
                              .emailController,
                          validator: (v) =>
                              v!.isEmpty ? 'ادخل ايميل التواصل' : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.phone],
                          keyboardType: TextInputType.phone,
                          title: 'رقم الجوال',
                          controller: context
                              .read<ClientCubit>()
                              .phoneController,
                          validator: (v) =>
                              v!.isEmpty ? 'ادخل رقم الجوال' : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          keyboardType: TextInputType.multiline,
                          title: 'تفاصيل عن البيزنس',
                          controller: context
                              .read<ClientCubit>()
                              .businessDetailsController,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                12.verticalSpace,

                // قسم الموقع
                InkWell(
                  onTap: _confirmAndGetLocation,
                  child: Card(
                    color: AppColors.whiteColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('الموقع', style: AppTextStyle.style14W800),

                              Icon(
                                Icons.add_location_alt_outlined,
                                size: 30.sp,
                                color: AppColors.primaryColor,
                              ),

                              // CustomPrimaryButton(
                              //   text: 'تحديد الموقع',
                              //   width: double.infinity,
                              //   height: 45.h,
                              //   icon: Icons.location_on,
                              //   onPressed: _confirmAndGetLocation,
                              // ),
                              // if (locationText != null) ...[
                              //   8.verticalSpace,
                              //   Text(locationText!, style: AppTextStyle.style14W500),
                              // ],
                            ],
                          ),
                          8.verticalSpace,
                          if (locationText != null) ...[
                            8.verticalSpace,
                            Text(
                              locationText!,
                              style: AppTextStyle.style14W500,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                12.verticalSpace,

                if (widget.client != null) ...[
                  const SizedBox.shrink(),
                ] else ...[
                  InkWell(
                    onTap: () => setState(() => isVisible = false),
                    child: Card(
                      color: AppColors.whiteColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('الزيارة', style: AppTextStyle.style14W800),
                            12.verticalSpace,
                            Visibility(
                              visible: isVisible,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الزيارة',
                                    style: AppTextStyle.style14W800,
                                  ),

                                  Icon(
                                    Icons.add,
                                    size: 30.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                              // child: CustomPrimaryButton(
                              //   text: 'إضافة زيارة',
                              //   width: double.infinity,
                              //   height: 45.h,
                              //   icon: Icons.add,
                              //   onPressed: () => setState(() => isVisible = false),
                              // ),
                            ),
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: CustomPrimaryTextfield(
                                keyboardType: TextInputType.multiline,
                                title: 'تفاصيل الزيارة',
                                controller: context
                                    .read<ClientCubit>()
                                    .visitDetailsController,
                                maxLines: 3,
                              ),
                              crossFadeState: isVisible
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                24.verticalSpace,

                // زر الحفظ
                CustomPrimaryButton(
                  text: widget.client == null ? 'حفظ' : 'تعديل',
                  width: double.infinity,
                  height: 50.h,
                  icon: Icons.save,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (cubit.latitude == null || cubit.longitude == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('من فضلك حدد الموقع')),
                      );
                      return;
                    }

                    if (widget.client == null) {
                      context.read<ClientCubit>().addClient();
                    } else {
                      context.read<ClientCubit>().updateClient(
                        widget.client!.id!,
                      );
                    }
                  },
                ),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
