import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class AllVisitsScreen extends StatelessWidget {
  const AllVisitsScreen({required this.visits, super.key});
  final List<ClientModel> visits;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الزيارات'),
      body: ListView.builder(
        itemCount: visits.length,
        itemBuilder: (context, index) {
          final visit = visits[index];

          return InkWell(
            onTap: () {
              context.pushNamed(
                AppRoutes.visitsDetailsScreen,
                extra: visit,
              );
            },
            child: ListTile(
              title: Text(visit.name),
              subtitle: Text('Area: ${visit.area}'),
            ),
          );
        },
      ),
    );
  }
}
