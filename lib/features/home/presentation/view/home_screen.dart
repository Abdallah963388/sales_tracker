import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/services/date_format.dart';
import 'package:sales_tracker/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sales_tracker/features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sales_tracker/features/visits/data/model/visits_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return BlocBuilder<RepHomeCubit, RepHomeState>(
      builder: (context, state) {
        if (state is RepHomeLoading) {
          return const Center(child: LoadingWidget());
        }

        if (state is RepHomeFailed) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state is RepHomeSuccess) {
          final stats = state.dashboard.data?.stats;
          final clients = state.dashboard.data?.recentClients ?? [];
          final visits = state.dashboard.data?.recentVisits ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<RepHomeCubit>().fetchRepHome();
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
                        style: AppTextStyle.style18Bold,
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
                    'الإحصائيات',
                    style: AppTextStyle.style16W800.copyWith(
                      color: AppColors.primaryDarkColor,
                    ),
                  ),

                  12.verticalSpace,

                  Row(
                    children: [
                      _statCard(
                        title: 'عدد الزيارات',
                        count: stats?.totalVisits ?? 0,
                        icon: Icons.location_on,
                        onTap: () =>
                            context.read<MainLayoutCubit>().gotoPage(2),
                      ),
                      12.horizontalSpace,
                      _statCard(
                        title: 'عدد العملاء',
                        count: stats?.totalClients ?? 0,
                        icon: IconlyBroken.user3,
                        onTap: () =>
                            context.read<MainLayoutCubit>().gotoPage(1),
                      ),
                    ],
                  ),

                  20.verticalSpace,

                  Text(
                    'الإجراءات',
                    style: AppTextStyle.style16W800.copyWith(
                      color: AppColors.primaryDarkColor,
                    ),
                  ),

                  12.verticalSpace,

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: [
                      _actionButton(
                        text: 'إضافة عميل',
                        icon: Icons.person_add,
                        onTap: () async {
                          final result = await context.pushNamed(
                            AppRoutes.addClientsScreen,
                          );
                          if (result == true) {
                            context.read<RepHomeCubit>().fetchRepHome();
                          }
                        },
                      ),
                      _actionButton(
                        text: 'إضافة زيارة',
                        icon: Icons.add_location_alt,
                        onTap: () async {
                          final result = await context.pushNamed(
                            AppRoutes.addVisitsScreen,
                          );
                          if (result == true) {
                            context.read<RepHomeCubit>().fetchRepHome();
                          }
                        },
                      ),
                    ],
                  ),

                  20.verticalSpace,

                  _section(
                    title: 'العملاء',
                    onViewAll: () =>
                        context.read<MainLayoutCubit>().gotoPage(1),
                  ),

                  if (clients.isEmpty)
                    _emptyState()
                  else
                    Column(
                      children: clients
                          .map((c) => _clientItem(context, c))
                          .toList(),
                    ),

                  20.verticalSpace,

                  _section(
                    title: 'الزيارات',
                    onViewAll: () =>
                        context.read<MainLayoutCubit>().gotoPage(2),
                  ),

                  if (visits.isEmpty)
                    _emptyState()
                  else
                    Column(
                      children: visits
                          .map((v) => _visitItem(context, v))
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
          height: 120.h,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryDarkColor,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white),
              const Spacer(),
              Text(title, style: AppTextStyle.style14W500.copyWith(color: AppColors.whiteColor)),
              Text(
                '$count',
                style:  AppTextStyle.style14W800.copyWith(color: AppColors.whiteColor)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.primaryColor.withOpacity(.1),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            10.horizontalSpace,
            Text(text, style: AppTextStyle.style14W800),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.style16W800.copyWith(
            color: AppColors.primaryDarkColor,
          ),
        ),
        InkWell(
          onTap: onViewAll,
          child: const Text('عرض الكل'),
        ),
      ],
    );
  }

  Widget _clientItem(BuildContext context, Client c) {
    return _cardItem(
      icon: Icons.person,
      title: c.clientName ?? '',
      subtitle: c.phone ?? '',
      onTap: () {
        context.pushNamed(AppRoutes.clientsDetailsScreen, extra: c);
      },
    );
  }

  Widget _visitItem(BuildContext context, Visit v) {
    return _cardItem(
      icon: Icons.location_on,
      title: "${v.client?.clientName ?? ''} - ${v.client?.region ?? ''}",
      subtitle: v.details ?? '',
      onTap: () {
        context.pushNamed(AppRoutes.visitsDetailsScreen, extra: v);
      },
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
    return Column(
      children: [
        const Icon(Icons.inbox, size: 50, color: Colors.grey),
        6.verticalSpace,
        const Text('لا توجد بيانات', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
