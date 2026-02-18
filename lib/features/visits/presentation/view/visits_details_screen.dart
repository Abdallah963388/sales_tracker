import 'package:flutter/material.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class VisitsDetailsScreen extends StatelessWidget {
  const VisitsDetailsScreen({required this.visit, super.key});
  final ClientModel visit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'تفاصيل الزيارة'),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              visit.name,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            12.verticalSpace,

            Text('اسم المكان: ${visit.placeName}'),
            8.verticalSpace,

            Text('المنطقة: ${visit.area}'),
            8.verticalSpace,

            Text('البريد: ${visit.email}'),
            8.verticalSpace,

            Text('الهاتف: ${visit.phone}'),
            8.verticalSpace,

            Text('تفاصيل: ${visit.details}'),
            8.verticalSpace,

            if (visit.location != null) Text('الموقع: ${visit.location}'),

            if (visit.visitDetails != null)
              Text('تفاصيل الزيارة: ${visit.visitDetails}'),
          ],
        ),
      ),
    );
  }
}
