import 'package:flutter/material.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class ClientsDetailsScreen extends StatelessWidget {
  const ClientsDetailsScreen({
    required this.client,
    super.key,
  });

  final ClientModel client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'تفاصيل العميل'),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              client.name,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            12.verticalSpace,

            Text('اسم المكان: ${client.placeName}'),
            8.verticalSpace,

            Text('المنطقة: ${client.area}'),
            8.verticalSpace,

            Text('البريد: ${client.email}'),
            8.verticalSpace,

            Text('الهاتف: ${client.phone}'),
            8.verticalSpace,

            Text('تفاصيل: ${client.details}'),
            8.verticalSpace,

            if (client.location != null) Text('الموقع: ${client.location}'),

            if (client.visitDetails != null)
              Text('تفاصيل الزيارة: ${client.visitDetails}'),
          ],
        ),
      ),
    );
  }
}
