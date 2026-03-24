import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/representative/data/model/rep_model.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_states.dart';

class RepScreen extends StatefulWidget {
  const RepScreen({super.key});

  @override
  State<RepScreen> createState() => _RepScreenState();
}

class _RepScreenState extends State<RepScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepCubit, RepState>(
      builder: (context, state) {
        if (state.status == RepStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == RepStatus.failure) {
          return Scaffold(
            body: Center(child: Text(state.error ?? 'حدث خطأ')),
          );
        }

        final allReps =
            state.reps
                ?.expand<Rep>((response) => response.data?.reps ?? [])
                .toList() ??
            [];

        final filteredReps = allReps.where((r) {
          return (r.name ?? '').toLowerCase().contains(search.toLowerCase()) ||
              (r.phone ?? '').contains(search);
        }).toList();

        return Scaffold(
          appBar: const CustomAppBar(title: 'المناديب'),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) {
                    setState(() => search = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'بحث عن مندوب...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: filteredReps.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredReps.length,
                        itemBuilder: (context, index) {
                          final rep = filteredReps[index];
                          return _repCard(context, rep);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.add, color: AppColors.whiteColor),
            onPressed: () {
              context.pushNamed(AppRoutes.addRepScreen);
            },
          ),
        );
      },
    );
  }

  Widget _repCard(BuildContext context, Rep rep) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.repDetailsScreen, extra: rep.id);
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
                (rep.name ?? 'R')[0],
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
                  Text(rep.name ?? '', style: AppTextStyle.style14W800),
                  const SizedBox(height: 4),
                  Text(
                    rep.phone ?? '',
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
          Text('لا يوجد مناديب', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
