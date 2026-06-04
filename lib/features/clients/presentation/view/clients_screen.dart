import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/clients/data/model/client_model.dart';
import 'package:sit/features/clients/presentation/controller/client_cubit.dart';
import 'package:sit/features/clients/presentation/controller/client_state.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        final allClients = state.clients!
            .expand<Client>(
              (clientsResponse) => clientsResponse.data?.clients ?? [],
            )
            .toList();

        final filteredClients = allClients.where((c) {
          return (c.clientName ?? '').toLowerCase().contains(
                search.toLowerCase(),
              ) ||
              (c.phone ?? '').contains(search);
        }).toList();

        return Scaffold(
          appBar: CustomAppBar(title: s.clients),

          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) {
                    setState(() => search = value);
                  },
                  decoration: InputDecoration(
                    hintText: s.clientsSearch,
                    hintStyle: AppTextStyle.style14W300.copyWith(
                      color: AppColors.secondaryColor.withAlpha(250),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.secondaryColor.withAlpha(250),
                    ),
                    filled: true,
                    fillColor: AppColors.primaryColor.withAlpha(30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: filteredClients.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredClients.length,
                        itemBuilder: (context, index) {
                          final client = filteredClients[index];
                          return _clientCard(context, client);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _clientCard(BuildContext context, Client client) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.clientsDetailsScreen,
          extra: client,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryColor.withOpacity(.1),
              child: Text(
                (client.clientName ?? 'A')[0],
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.clientName ?? '',
                    style: AppTextStyle.style14W800,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    client.phone ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'لا يوجد عملاء',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
