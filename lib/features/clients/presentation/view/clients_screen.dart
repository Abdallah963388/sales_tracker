import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({
    required this.clients,
    super.key,
  });

  final List<ClientModel> clients;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'العملاء'),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];

          return InkWell(
            onTap: () {
              context.pushNamed(
                AppRoutes.clientsDetailsScreen,
                extra: client,
              );
            },
            child: ListTile(
              title: Text(client.name),
              subtitle: Text('Phone: ${client.phone}'),
            ),
          );
        },
      ),
    );
  }
}
