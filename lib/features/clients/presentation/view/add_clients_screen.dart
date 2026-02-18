import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_button.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';

// ignore: must_be_immutable
class AddClientsScreen extends StatefulWidget {
  const AddClientsScreen({super.key});

  @override
  State<AddClientsScreen> createState() => _AddClientsScreenState();
}

class _AddClientsScreenState extends State<AddClientsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController visitDetailsController = TextEditingController();

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
    final location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // تأكد إن الـ GPS شغال
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // اطلب الصلاحية
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();

    setState(() {
      locationText =
          'Lat: ${locationData.latitude}, Lng: ${locationData.longitude}';
      log(locationText.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'إضافة عملاء'),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            CustomPrimaryTextfield(
              text: 'الاسم',
              validator: (v) => v!.isEmpty ? 'ادخل الاسم' : null,
            ),
            12.verticalSpace,
            const CustomPrimaryTextfield(
              text: 'اسم المكان',
            ),
            12.verticalSpace,
            const CustomPrimaryTextfield(
              text: 'المنطقة',
            ),
            12.verticalSpace,
            CustomPrimaryTextfield(
              text: 'ايميل التواصل',
              validator: (v) => v!.isEmpty ? 'ادخل ايميل التواصل' : null,
            ),
            12.verticalSpace,
            CustomPrimaryTextfield(
              text: 'رقم الجوال',
              validator: (v) => v!.isEmpty ? 'ادخل رقم الجوال' : null,
            ),
            12.verticalSpace,
            const CustomPrimaryTextfield(
              text: 'تفاصيل عن البيزنس',
              maxLines: 3,
            ),
            12.verticalSpace,
            CustomPrimaryButton(
              text: 'تحديد الموقع',
              width: 200.w,
              height: 20.h,
              icon: Icons.location_on,
              onPressed: _confirmAndGetLocation,
            ),
            12.verticalSpace,
            if (isVisible == true)
              CustomPrimaryButton(
                text: 'إضافة زيارة',
                width: 200.w,
                height: 20.h,
                icon: Icons.add,
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              )
            else
              const SizedBox.shrink(),
            12.verticalSpace,

            if (isVisible == false)
              const CustomPrimaryTextfield(
                text: 'تفاصيل الزيارة',
                maxLines: 3,
              )
            else ...[
              const SizedBox.shrink(),
            ],
            12.verticalSpace,
            CustomPrimaryButton(
              text: 'حفظ',
              width: 200.w,
              height: 20.h,
              onPressed: () async {
                final newClient = ClientModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: nameController.text,
                  placeName: placeController.text,
                  area: areaController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  details: detailsController.text,
                  location: locationText,
                  visitDetails: visitDetailsController.text,
                );

                // لو عندك Cubit تقدر تنادي addClient زي ما عندك
                await context.read<ClientCubit>().addClient(newClient);

                // ارجع العميل الجديد للصفحة السابقة
                context.pop(newClient);
              },
            ),
          ],
        ),
      ),
    );
  }
}
