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

class AllClientsScreen extends StatefulWidget {
  const AllClientsScreen({super.key});

  @override
  State<AllClientsScreen> createState() => _AllClientsScreenState();
}

class _AllClientsScreenState extends State<AllClientsScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        final allClients =
            state.allClients
                ?.expand<Client>(
                  (e) => e.data?.clients ?? [],
                )
                .toList() ??
            [];

        final filtered = allClients.where((c) {
          return (c.clientName ?? '').toLowerCase().contains(
                search.toLowerCase(),
              ) ||
              (c.phone ?? '').contains(search);
        }).toList();

        return Scaffold(
          appBar: CustomAppBar(title: s.allClients),

          floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: AppColors.primaryColor,
            child: const Icon(
              Icons.add,
              color: AppColors.whiteColor,
            ),
            onPressed: () async {
              final result = await context.pushNamed(
                AppRoutes.addClientsScreen,
              );
              if (result == true) {
                context.read<ClientCubit>().getAllClients();
              }
            },
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ClientCubit>().getAllClients();
            },
            child: Column(
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

                if (state.status == ClientStatus.loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == ClientStatus.failure)
                  Expanded(
                    child: _errorState(state.error, context),
                  )
                else if (filtered.isEmpty)
                  const Expanded(child: _emptyState())
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _clientCard(context, filtered[index]);
                      },
                    ),
                  ),
              ],
            ),
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

  Widget _errorState(String? error, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            error ?? S.of(context)!.error,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class _emptyState extends StatelessWidget {
  const _emptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.thereIsNoClients,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
