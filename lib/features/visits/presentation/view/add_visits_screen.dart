import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/shared_widgets/custom_drop_down_form_field.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_button.dart';
import 'package:sales_tracker/core/shared_widgets/custom_primary_textfield.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class AddVisitsScreen extends StatefulWidget {
  const AddVisitsScreen({super.key});

  @override
  State<AddVisitsScreen> createState() => _AddVisitsScreenState();
}

class _AddVisitsScreenState extends State<AddVisitsScreen> {
  int? selectedClientId;
  final TextEditingController visitDetailsController = TextEditingController();
  String? locationText;

  // قائمة العملاء الثابتة
  final List<ClientModel> clients = [
    ClientModel(
      id: 1,
      name: 'Ahmad Ali',
      placeName: 'Shop 1',
      area: 'Cairo',
      email: 'ahmad@example.com',
      phone: '01012345678',
      details: 'Electronics shop',
    ),
    ClientModel(
      id: 2,
      name: 'Sara Mohamed',
      placeName: 'Shop 2',
      area: 'Giza',
      email: 'sara@example.com',
      phone: '01087654321',
      details: 'Clothes store',
    ),
    ClientModel(
      id: 3,
      name: 'Ali Hassan',
      placeName: 'Shop 3',
      area: 'Alexandria',
      email: 'ali@example.com',
      phone: '01011223344',
      details: 'Bookstore',
    ),
    ClientModel(
      id: 4,
      name: 'Abdallah Jamal',
      placeName: 'Shop 4',
      area: 'Mynia',
      email: 'abdallah@example.com',
      phone: '01011223344',
      details: 'Mobile store',
    ),
    ClientModel(
      id: 5,
      name: 'Ahmed Mahmoud',
      placeName: 'Shop 5',
      area: 'Aswan',
      email: 'a@example.com',
      phone: '01011223344',
      details: 'Shoes store',
    ),
  ];

  Future<void> _confirmAndGetLocation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );

    if (confirm != true) return;
    await _getLocation();
  }

  Future<void> _getLocation() async {
    final location = Location();

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final locationData = await location.getLocation();
    setState(() {
      locationText =
          'Lat: ${locationData.latitude}, Lng: ${locationData.longitude}';
      log(locationText.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'إضافة زيارة'),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            CustomDropdownField<int>(
              label: 'اختر عميل',
              hint: 'اختر عميل',
              items: clients.map((client) {
                return DropdownMenuItem<int>(
                  value: client.id,
                  child: Text(client.name),
                );
              }).toList(),
              value: selectedClientId,
              onChanged: (value) {
                setState(() {
                  selectedClientId = value;
                });
              },
            ),
            12.verticalSpace,
            CustomPrimaryButton(
              text: 'تحديد الموقع',
              width: 200.w,
              height: 20.h,
              icon: Icons.location_on,
              onPressed: _confirmAndGetLocation,
            ),
            if (locationText != null) ...[
              8.verticalSpace,
              Text(
                locationText!,
                style: AppTextStyle.style14W500.copyWith(
                  color: AppColors.blackColor.withAlpha(100),
                ),
              ),
            ],
            12.verticalSpace,
            CustomPrimaryTextfield(
              text: 'تفاصيل الزيارة',
              controller: visitDetailsController,
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'ادخل تفاصيل الزيارة' : null,
            ),
            12.verticalSpace,
            CustomPrimaryButton(
              text: 'حفظ الزيارة',
              width: 200.w,
              height: 20.h,
              onPressed: () {
                if (selectedClientId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('اختر العميل أولاً')),
                  );
                  return;
                }

                log(
                  'عميل: $selectedClientId, تفاصيل: ${visitDetailsController.text}, موقع: $locationText',
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
