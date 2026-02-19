import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class RepresentativesDetailsScreen extends StatelessWidget {
  const RepresentativesDetailsScreen({required this.representative, super.key});
  final ClientModel representative;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'تفاصيل المندوب',
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 24.r,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              context.pushNamed(
                AppRoutes.representativeManagementScreen,
                extra: representative,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              representative.name,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            12.verticalSpace,

            Text('اسم المكان: ${representative.placeName}'),
            8.verticalSpace,

            Text('المنطقة: ${representative.area}'),
            8.verticalSpace,

            Text('البريد: ${representative.email}'),
            8.verticalSpace,

            Text('الهاتف: ${representative.phone}'),
            8.verticalSpace,

            Text('تفاصيل: ${representative.details}'),
            8.verticalSpace,

            if (representative.location != null)
              Text('الموقع: ${representative.location}'),

            if (representative.visitDetails != null)
              Text('تفاصيل المندوب: ${representative.visitDetails}'),
          ],
        ),
      ),
    );
  }
}
