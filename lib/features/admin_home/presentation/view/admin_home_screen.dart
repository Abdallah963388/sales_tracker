import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/services/date_format.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sit/features/admin_home/presentation/controller/admin_home_states.dart';
import 'package:sit/features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final s = S.of(context)!;
    return BlocBuilder<AdminHomeCubit, AdminHomeStates>(
      builder: (context, state) {
        if (state is AdminHomeLoading) {
          return const Center(child: LoadingWidget());
        }
        if (state is AdminHomeFailed) {
          return Center(child: Text('Error: ${state.error}'));
        }
        if (state is AdminHomeSuccess) {
          final stats = state.dashboard.data?.stats;
          final clients = state.dashboard.data?.recentClients ?? [];
          final reps = state.dashboard.data?.recentReps ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AdminHomeCubit>().fetchAdminHome();
            },
            child: Scaffold(
              body: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreetingWithEmoji(context),
                        style: AppTextStyle.style18Bold.copyWith(
                          color: AppColors.blackColor.withAlpha(200),
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        formattedDate(locale),
                        style: AppTextStyle.style12W500.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,

                  Text(
                    s.statistics,
                    style: AppTextStyle.style16W700.copyWith(
                      color: AppColors.blackColor.withAlpha(200),
                    ),
                  ),
                  12.verticalSpace,

                  Row(
                    spacing: 8.w,
                    children: [
                      _statCard(
                        title: s.numberOfClients,
                        count: stats?.totalClients ?? 0,
                        icon: IconlyBroken.user3,
                        onTap: () =>
                            context.read<SalesMainLayoutCubit>().gotoPage(1),
                      ),
                      _statCard(
                        title: s.numberOfVisits,
                        count: stats?.totalVisits ?? 0,
                        icon: Icons.view_compact_rounded,
                        onTap: () =>
                            context.read<SalesMainLayoutCubit>().gotoPage(3),
                      ),
                      _statCard(
                        title: s.numberOfReps,
                        count: stats?.totalReps ?? 0,
                        icon: Icons.groups,
                        onTap: () =>
                            context.read<SalesMainLayoutCubit>().gotoPage(2),
                      ),
                    ],
                  ),

                  24.verticalSpace,

                  // 🔹 Actions
                  // Text(
                  //   'الإجراءات',
                  //   style: AppTextStyle.style16W800.copyWith(
                  //     color: AppColors.primaryDarkColor,
                  //   ),
                  // ),
                  // 12.verticalSpace,

                  // GridView.count(
                  //   crossAxisCount: 2,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   crossAxisSpacing: 12,
                  //   mainAxisSpacing: 12,
                  //   childAspectRatio: 2.5,
                  //   children: [
                  //     _actionButton(
                  //       text: 'إضافة عميل',
                  //       icon: Icons.person_add,
                  //       onTap: () async {
                  //         final result = await context.pushNamed(
                  //           AppRoutes.addClientsScreen,
                  //         );
                  //         if (result == true) {
                  //           context.read<AdminHomeCubit>().fetchAdminHome();
                  //         }
                  //       },
                  //     ),
                  //     _actionButton(
                  //       text: 'إضافة مندوب',
                  //       icon: Icons.person,
                  //       onTap: () async {
                  //         // هنا رابط إضافة مندوب
                  //       },
                  //     ),
                  //   ],
                  // ),

                  // 20.verticalSpace,

                  // 🔹 Recent Reps
                  _section(
                    context: context,
                    title: s.reps,
                    onViewAll: () {
                      context.read<SalesMainLayoutCubit>().gotoPage(2);
                    },
                  ),
                  12.verticalSpace,
                  if (reps.isEmpty)
                    _emptyState()
                  else
                    Column(
                      children: reps
                          .map(
                            (r) => _cardItem(
                              icon: Icons.groups,
                              title: r.name ?? '',
                              subtitle: r.phone ?? '',
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.repDetailsScreen,
                                  extra: r.id,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),

                  20.verticalSpace,

                  _section(
                    context: context,
                    title: s.clients,
                    onViewAll: () {
                      context.read<SalesMainLayoutCubit>().gotoPage(1);
                    },
                  ),
                  12.verticalSpace,
                  if (clients.isEmpty)
                    _emptyState()
                  else
                    Column(
                      children: clients
                          .map(
                            (c) => _cardItem(
                              icon: Icons.person,
                              title: c.clientName ?? '',
                              subtitle: c.phone ?? '',
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.clientsDetailsScreen,
                                  extra: c,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _statCard({
    required String title,
    required int count,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 140.h,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16.r),

            // gradient: const LinearGradient(
            //   colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.whiteColor.withAlpha(100),
                size: 32.r,
              ),
              8.verticalSpace,
              Text(
                title,
                style: AppTextStyle.style12W500.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$count',
                    style: AppTextStyle.style20Bold.copyWith(
                      color: AppColors.whiteColor.withAlpha(220),
                    ),
                  ),
                  12.horizontalSpace,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required VoidCallback onViewAll,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.style16W700.copyWith(
            color: AppColors.blackColor.withAlpha(200),
          ),
        ),
        InkWell(
          onTap: onViewAll,
          child: Text(
            S.of(context)!.viewAll,
            style: AppTextStyle.style12Bold.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(.1),
              child: Icon(icon, color: AppColors.primaryColor),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.style14W800),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
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
    return const Column(
      children: [
        Icon(Icons.inbox, size: 50, color: Colors.grey),
        SizedBox(height: 6),
        Text('لا توجد بيانات', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
