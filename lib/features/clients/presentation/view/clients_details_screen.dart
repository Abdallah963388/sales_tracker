import 'package:flutter/material.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class ClientsDetailsScreen extends StatefulWidget {
  const ClientsDetailsScreen({
    required this.client,
    super.key,
  });

  final ClientModel client;

  @override
  State<ClientsDetailsScreen> createState() => _ClientsDetailsScreenState();
}

class _ClientsDetailsScreenState extends State<ClientsDetailsScreen> {
  final bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'تفاصيل العميل'),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.client.name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 24.r,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {},
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
            12.verticalSpace,

            Text('اسم المكان: ${widget.client.placeName}'),
            8.verticalSpace,

            Text('المنطقة: ${widget.client.area}'),
            8.verticalSpace,

            Text('البريد: ${widget.client.email}'),
            8.verticalSpace,

            Text('الهاتف: ${widget.client.phone}'),
            8.verticalSpace,

            Text('تفاصيل: ${widget.client.details}'),
            8.verticalSpace,

            if (widget.client.location != null)
              Text('الموقع: ${widget.client.location}'),

            if (widget.client.visitDetails != null)
              Text('تفاصيل الزيارة: ${widget.client.visitDetails}'),
          ],
        ),
      ),
    );
  }
}
