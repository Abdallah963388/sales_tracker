import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/visits/data/model/visits_model.dart';
import 'package:sit/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sit/features/visits/presentation/controller/visits_states.dart';

class AllVisitsScreen extends StatefulWidget {
  const AllVisitsScreen({super.key});

  @override
  State<AllVisitsScreen> createState() => _AllVisitsScreenState();
}

class _AllVisitsScreenState extends State<AllVisitsScreen> {
  String search = '';
  @override
  void initState() {
    super.initState();
    context.read<VisitsCubit>().getAllVisits();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BlocBuilder<VisitsCubit, VisitState>(
      builder: (context, state) {
        final allVisits =
            state.allVisits
                ?.expand<Visit>((e) => e.data?.visits ?? [])
                .toList() ??
            [];

        final filtered = allVisits.where((v) {
          return (v.client?.clientName ?? '').toLowerCase().contains(
                search.toLowerCase(),
              ) ||
              (v.client?.region ?? '').toLowerCase().contains(
                search.toLowerCase(),
              ) ||
              (v.details ?? '').toLowerCase().contains(search.toLowerCase());
        }).toList();

        return Scaffold(
          appBar: CustomAppBar(title: s.allVisits),

          /// ➕ Add Visit
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: AppColors.primaryColor,
          //   child: const Icon(Icons.add_location_alt),
          //   onPressed: () async {
          //     final result = await context.pushNamed(AppRoutes.addVisitsScreen);
          //     if (result == true) {
          //       context.read<VisitsCubit>().getAllVisits();
          //     }
          //   },
          // ),
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<VisitsCubit>().getAllVisits();
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
                      hintText: s.visitsSearch,
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
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                if (state.status == VisitStatus.allLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == VisitStatus.failure)
                  Expanded(child: _errorState(state.error, context))
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
                    visit.client?.clientName ?? '',
                    style: AppTextStyle.style14W800,
                  ),
                  4.verticalSpace,
                  Text(
                    visit.client?.region ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  4.verticalSpace,
                  Text(
                    visit.details ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_off, size: 60, color: Colors.grey),
        const SizedBox(height: 10),
        Text(
          S.of(context)!.thereIsNoVisits,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
