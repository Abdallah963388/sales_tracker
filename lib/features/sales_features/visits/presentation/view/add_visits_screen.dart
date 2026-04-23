import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/services/input_formatters.dart';
import 'package:sit/core/services/loading.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/shared_widgets/custom_drop_down_form_field.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/sales_features/clients/data/model/client_model.dart';
import 'package:sit/features/sales_features/clients/presentation/controller/client_cubit.dart';
import 'package:sit/features/sales_features/clients/presentation/controller/client_state.dart';
import 'package:sit/features/sales_features/visits/presentation/controller/visits_cubit.dart';
import 'package:sit/features/sales_features/visits/presentation/controller/visits_states.dart';

class AddVisitsScreen extends StatefulWidget {
  const AddVisitsScreen({super.key});

  @override
  State<AddVisitsScreen> createState() => _AddVisitsScreenState();
}

class _AddVisitsScreenState extends State<AddVisitsScreen> {
  PlatformFile? selectedFile;
  String? locationText;

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
                S.of(context)!.close,
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

    final cubit = context.read<VisitsCubit>()
      ..latitude = locationData.latitude
      ..longitude = locationData.longitude;
    cubit.locationNameController.text =
        '${locationData.latitude}, ${locationData.longitude}';

    setState(() {
      locationText = cubit.locationNameController.text;
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

  Future<void> _pickFile(VisitsCubit cubit) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      cubit.attachmentFile = result.files.first;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ClientCubit>().getClients();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final visitsCubit = context.read<VisitsCubit>();

    return BlocListener<VisitsCubit, VisitState>(
      listener: (context, state) {
        if (state.status == VisitStatus.addSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? s.visitAddedSuccessfully)),
          );

          context.pop(true);
        }

        if (state.status == VisitStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? s.error)),
          );
        }
      },
      child: Scaffold(
        appBar:  CustomAppBar(
          title: s.addVisit,
          canBack: true,
        ),
        body: BlocBuilder<ClientCubit, ClientState>(
          builder: (context, clientState) {
            // if (clientState.status == ClientStatus.loading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (clientState.status == ClientStatus.failure) {
              return Center(
                child: Text('${s.error}: ${clientState.error ?? ''}'),
              );
            }

            var clients = <Client>[];

            final allClients = clientState.clients;

            if (allClients != null) {
              clients = allClients
                  .expand<Client>(
                    (clientsResponse) =>
                        clientsResponse.data?.clients?.map(
                          (c) => Client(
                            id: c.id ?? 0,
                            clientName: c.clientName ?? '',
                            businessName: c.businessName ?? '',
                            region: c.region ?? '',
                            email: c.email ?? '',
                            phone: c.phone ?? '',
                            businessDetails: c.businessDetails ?? '',
                          ),
                        ) ??
                        [],
                  )
                  .toList();
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(12.r),
                children: [
                  Card(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.chooseClient, style: AppTextStyle.style14W800),
                          8.verticalSpace,
                          CustomDropdownField<int>(
                            // label: 'اختر عميل',
                            hint: s.chooseClient,
                            value: visitsCubit.selectedClientId,
                            items: clients.map<DropdownMenuItem<int>>((client) {
                              return DropdownMenuItem(
                                value: client.id,
                                child: Text(client.clientName ?? ''),
                              );
                            }).toList(),
                            onChanged: (v) => setState(
                              () => visitsCubit.selectedClientId = v,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  12.verticalSpace,

                  InkWell(
                    onTap: _confirmAndGetLocation,
                    child: Card(
                      color: AppColors.whiteColor,
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          children: [
                            CustomPrimaryTextfield(
                              inputFormatters: [AppInputFormatters.address],
                              keyboardType: TextInputType.text,
                              title: s.address,
                              controller: visitsCubit.addressNameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return s.pleaseEnterAddress;
                                }
                                return null;
                              },
                            ),
                            24.verticalSpace,
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(s.location, style: AppTextStyle.style14W800),
                                if (locationText != null) ...[
                                  8.horizontalSpace,
                                  Text(
                                    locationText!,
                                    style: AppTextStyle.style14W500,
                                  ),
                                ],
                                const Spacer(),
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
                                //   onPressed: () => _confirmAndGetLocation(visitsCubit),
                                // ),
                              ],
                            ),
                            8.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  Card(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomPrimaryTextfield(
                            keyboardType: TextInputType.multiline,
                            title: s.visitDetails,
                            controller: visitsCubit.visitDetailsController,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return s.pleaseEnterVisitDetails;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  InkWell(
                    onTap: () => _pickFile(visitsCubit),
                    child: Card(
                      color: AppColors.whiteColor,
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  s.attachFile,
                                  style: AppTextStyle.style14W800,
                                ),
                                Icon(
                                  Icons.attach_file,
                                  size: 30.sp,
                                  color: AppColors.primaryColor,
                                ),
                                // CustomPrimaryButton(
                                //     text: 'إرفاق ملف',
                                //     width: double.infinity,
                                //     height: 45.h,
                                //     icon: Icons.attach_file,
                                //     onPressed: () => _pickFile(visitsCubit),
                                //   ),
                              ],
                            ),
                            8.verticalSpace,
                            if (visitsCubit.attachmentFile != null)
                              Text(
                                visitsCubit.attachmentFile!.name,
                                style: AppTextStyle.style12W500.copyWith(
                                  color: AppColors.primaryDarkColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  CustomPrimaryButton(
                    text: s.save,
                    width: double.infinity,
                    height: 50.h,
                    icon: Icons.save,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (visitsCubit.selectedClientId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(s.pleaseChooseClient),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                        return;
                      }
                      if (visitsCubit.latitude == null ||
                          visitsCubit.longitude == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(s.pleasePickLocation),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                        return;
                      }
                      context.read<VisitsCubit>().addVisit();
                    },
                  ),
                  40.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
