import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class RepresentativesScreen extends StatelessWidget {
  const RepresentativesScreen({required this.representatives, super.key});
  final List<ClientModel> representatives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المناديب'),
      body: ListView.builder(
        itemCount: representatives.length,
        itemBuilder: (context, index) {
          final representative = representatives[index];

          return InkWell(
            onTap: () {
              context.pushNamed(
                AppRoutes.representativeDetailsScreen,
                extra: representative,
              );
            },
            child: ListTile(
              title: Text(representative.name),
              subtitle: Text('Area: ${representative.area}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.pushNamed(AppRoutes.representativeManagementScreen);
        },
      ),
    );
  }
}
