import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:pay/pay.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/services/input_formatters.dart';
import 'package:sit/core/services/loading.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/clients/data/model/client_model.dart';
import 'package:sit/features/clients/presentation/controller/client_cubit.dart';
import 'package:sit/features/clients/presentation/controller/client_state.dart';
import 'package:sit/features/home/presentation/controller/rep_home_cubit.dart';

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
  late Future<PaymentConfiguration> paymentConfig;

  Future<void> _confirmAndGetLocation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context)!.confirm),
          content: Text(S.of(context)!.doYouWantToPickYourCurrentLocation),
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
              child: Text(S.of(context)!.confirm),
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
        SnackBar(
          content: Text(S.of(context)!.locationPickedSuccessfully),
          duration: const Duration(seconds: 2),
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
    paymentConfig = PaymentConfiguration.fromAsset(
      'assets/apple_pay.json',
    );

    rootBundle
        .loadString('assets/apple_pay.json')
        .then((value) {
          debugPrint(value);
        })
        .catchError((e) {
          debugPrint(e.toString());
        });
  }

  @override
  void dispose() {
    if (mounted) cubit.resetForm();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BlocListener<ClientCubit, ClientState>(
      listener: (context, state) {
        if (state.status == ClientStatus.addSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? s.clientAddedSuccessfully),
              ),
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
          title: widget.client == null ? s.addClient : s.editClient,
          canBack: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.clientInformation, style: AppTextStyle.style14W800),
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
                          title: s.name,
                          controller: context
                              .read<ClientCubit>()
                              .clientNameController,
                          validator: (v) => v!.isEmpty ? s.enterName : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.businessName],
                          keyboardType: TextInputType.text,
                          title: s.businessName,
                          controller: context
                              .read<ClientCubit>()
                              .businessNameController,
                          validator: (v) =>
                              v!.isEmpty ? s.enterBusinessName : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.businessName],
                          keyboardType: TextInputType.text,
                          title: s.region,
                          controller: context
                              .read<ClientCubit>()
                              .regionController,
                          validator: (v) => v!.isEmpty ? s.enterRegion : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.email],
                          keyboardType: TextInputType.emailAddress,
                          title: s.email,
                          controller: context
                              .read<ClientCubit>()
                              .emailController,
                          validator: (v) => v!.isEmpty ? s.enterEmail : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          inputFormatters: [AppInputFormatters.phone],
                          keyboardType: TextInputType.phone,
                          title: s.phone,
                          controller: context
                              .read<ClientCubit>()
                              .phoneController,
                          validator: (v) => v!.isEmpty ? s.enterPhone : null,
                        ),
                        12.verticalSpace,
                        CustomPrimaryTextfield(
                          keyboardType: TextInputType.multiline,
                          title: s.businessDetails,
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
                              Text(s.location, style: AppTextStyle.style14W800),

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
                                    s.visit,
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
                                title: s.visitDetails,
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
                  text: widget.client == null ? s.save : s.edit,
                  width: double.infinity,
                  height: 50.h,
                  icon: Icons.save,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (cubit.latitude == null || cubit.longitude == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(s.pleasePickLocation)),
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
                20.verticalSpace,
                FutureBuilder<PaymentConfiguration>(
                  future: paymentConfig,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return const Text('No Data');
                    }

                    return ApplePayButton(
                      paymentConfiguration: snapshot.data!,
                      paymentItems: const [
                        PaymentItem(
                          label: 'Total',
                          amount: '100.00',
                          status: PaymentItemStatus.final_price,
                        ),
                      ],
                      type: ApplePayButtonType.buy,
                      onPaymentResult: print,
                    );
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
