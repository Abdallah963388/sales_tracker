import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/visits/data/model/visits_model.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_states.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitsCubit, VisitState>(
      builder: (context, state) {
        final allVisits =
            state.visits
                ?.expand<Visit>(
                  (e) => e.data?.visits ?? [],
                )
                .toList() ??
            [];

        final filtered = allVisits.where((v) {
          return (v.locationName ?? '').toLowerCase().contains(
                search.toLowerCase(),
              ) ||
              (v.details ?? '').toLowerCase().contains(search.toLowerCase());
        }).toList();

        return Scaffold(
          appBar: const CustomAppBar(title: 'الزيارات'),

          body: RefreshIndicator(
            onRefresh: () async {
              context.read<VisitsCubit>().getVisits();
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => search = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'بحث عن زيارة...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                if (state.status == VisitStatus.loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == VisitStatus.loading)
                  Expanded(
                    child: _errorState(state.message),
                  )
                else if (filtered.isEmpty)
                  const Expanded(child: _emptyState())
                else
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _visitCard(context, filtered[index]);
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

  Widget _visitCard(BuildContext context, Visit visit) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.visitsDetailsScreen,
          extra: visit,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
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
              child: const Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visit.locationName ?? '',
                    style: AppTextStyle.style14W800,
                  ),
                  4.verticalSpace,
                  Text(
                    visit.details ?? '',
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

  Widget _errorState(String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            error ?? 'حدث خطأ',
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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_off, size: 60, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          'لا توجد زيارات',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
