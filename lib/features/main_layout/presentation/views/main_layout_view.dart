import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sales_tracker/core/cache_helper/cache_helper.dart';
import 'package:sales_tracker/core/cache_helper/cache_values.dart';
import 'package:sales_tracker/core/cache_helper/user_role.dart';
import 'package:sales_tracker/core/di.dart';
import 'package:sales_tracker/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sales_tracker/features/admin_home/presentation/view/admin_home_screen.dart';
import 'package:sales_tracker/features/auth/presentation/controllers/auth_cubit.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';
import 'package:sales_tracker/features/clients/presentation/view/all_clients_screen.dart';
import 'package:sales_tracker/features/clients/presentation/view/clients_screen.dart';
import 'package:sales_tracker/features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sales_tracker/features/home/presentation/view/home_screen.dart';
import 'package:sales_tracker/features/profile/presentation/controller/profile_cubit.dart';
import 'package:sales_tracker/features/profile/presentation/view/profile_screen.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sales_tracker/features/representative/presentation/view/rep_screen.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sales_tracker/features/visits/presentation/view/all_visits_screen.dart';
import 'package:sales_tracker/features/visits/presentation/view/visit_screen.dart';

import '/../core/localization/s.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/theme/app_colors.dart';
import '/../features/main_layout/data/models/tab_item_model.dart';
import '/../features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import '/../features/my_app/controller/localization_cubit/localization_cubit.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  late final PageController pageController;
  late final MainLayoutCubit cubit;

  String? userRole;
  String? userId;

  // Cubits
  late final RepHomeCubit repHomeCubit;
  late final ClientCubit clientCubit;
  late final VisitsCubit visitsCubit;
  late final ProfileCubit profileCubit;
  late final LoginCubit loginCubit;

  late final AdminHomeCubit adminHomeCubit;
  late final RepCubit repCubit;

  Future<String> checkRole() async {
    userId = CacheHelper.getData(key: CacheKeys.userId).toString();
    userRole =
        CacheHelper.getData(key: CacheKeys.userRole)?.toString() ?? 'rep';
    return userRole.toString();
  }

  @override
  void initState() {
    super.initState();

    cubit = context.read<MainLayoutCubit>();

    cubit.controller = PageController(
      initialPage: cubit.state.currentIndex,
    );
    pageController = cubit.controller!;

    // initialize cubits once
    repHomeCubit = getIt<RepHomeCubit>();
    clientCubit = getIt<ClientCubit>();
    visitsCubit = getIt<VisitsCubit>();
    profileCubit = getIt<ProfileCubit>();
    loginCubit = getIt<LoginCubit>();
    adminHomeCubit = getIt<AdminHomeCubit>();
    repCubit = getIt<RepCubit>();

    checkRole().then((role) {
      if (!mounted) return;

      _loadInitialData();
      _setupTabs();
    });
  }

  void _loadInitialData() {
    if (userRole == UserRole.rep) {
      repHomeCubit.fetchRepHome();
      clientCubit.getClients();
      visitsCubit.getVisits();
      profileCubit.getProfile();
    } else if (userRole == UserRole.admin) {
      adminHomeCubit.fetchAdminHome();
      clientCubit.getAllClients();
      repCubit.getReps();
      visitsCubit.getAllVisits();
      profileCubit.getProfile();
    }
  }

  void _setupTabs() {
    if (!mounted) return;

    final s = S.of(context)!;

    cubit.setTabs([
      if (userRole == UserRole.rep) ...[
        TabItemModel(
          label: s.home,
          icon: IconlyBroken.home,
          page: BlocProvider.value(
            value: repHomeCubit,
            child: const HomeScreen(),
          ),
        ),
        TabItemModel(
          label: s.clients,
          icon: IconlyBroken.user3,
          page: BlocProvider.value(
            value: clientCubit,
            child: const ClientsScreen(),
          ),
        ),
        TabItemModel(
          label: s.visits,
          icon: IconlyBroken.work,
          page: BlocProvider.value(
            value: visitsCubit,
            child: const VisitScreen(),
          ),
        ),
        TabItemModel(
          label: s.profile,
          icon: IconlyBroken.profile,
          page: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: profileCubit),
              BlocProvider.value(value: loginCubit),
            ],
            child: const ProfileView(),
          ),
        ),
      ] else if (userRole == UserRole.admin) ...[
        TabItemModel(
          label: s.home,
          icon: IconlyBroken.home,
          page: BlocProvider.value(
            value: adminHomeCubit,
            child: const AdminHomeScreen(),
          ),
        ),
        TabItemModel(
          label: s.clients,
          icon: IconlyBroken.user3,
          page: BlocProvider.value(
            value: clientCubit,
            child: const AllClientsScreen(),
          ),
        ),
        TabItemModel(
          label: s.reps,
          icon: IconlyBroken.work,
          page: BlocProvider.value(
            value: repCubit,
            child: const RepScreen(),
          ),
        ),
        TabItemModel(
          label: s.visits,
          icon: IconlyBroken.discovery,
          page: BlocProvider.value(
            value: visitsCubit,
            child: const AllVisitsScreen(),
          ),
        ),
        TabItemModel(
          label: s.profile,
          icon: IconlyBroken.profile,
          page: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: profileCubit),
              BlocProvider.value(value: loginCubit),
            ],
            child: const ProfileView(),
          ),
        ),
      ],
    ]);
  }

  @override
  void dispose() {
    cubit.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        return BlocBuilder<MainLayoutCubit, MainLayoutState>(
          builder: (context, state) {
            if (state.tabs.isEmpty) {
              log(userRole.toString());
              return const Scaffold(
                body: Center(child: LoadingWidget()),
              );
            }
            log(state.tabs.length.toString());

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;

                if (state.currentIndex != 0) {
                  cubit.gotoPage(
                    0,
                  );
                  return;
                }
                cubit.backPressCount++;
                if (cubit.backPressCount == 1) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Container(
                          margin: EdgeInsets.all(4.r),
                          padding: EdgeInsets.symmetric(vertical: 10.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(220),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            'اضغط مرة أخرى للخروج',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.style14W500.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  Future.delayed(const Duration(seconds: 2), () {
                    cubit.backPressCount = 0;
                  });

                  return;
                }
                SystemNavigator.pop();
              },

              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 10.h,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryDarkColor,
                        ],
                      ),
                    ),
                  ),
                ),
                body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: cubit.gotoPage,
                  children: state.tabs.map((t) => t.page).toList(),
                ),
                bottomNavigationBar: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: BottomNavigationBar(
                    backgroundColor: AppColors.whiteColor,
                    useLegacyColorScheme: false,
                    currentIndex: state.currentIndex,
                    onTap: cubit.gotoPage,
                    selectedItemColor: AppColors.primaryDarkColor,
                    unselectedItemColor: AppColors.blackColor.withAlpha(150),
                    type: BottomNavigationBarType.fixed,
                    items: List.generate(state.tabs.length, (index) {
                      final tab = state.tabs[index];
                      final isActive = index == state.currentIndex;
                      return BottomNavigationBarItem(
                        icon: isActive
                            ? Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(320.r),
                                  border: Border.all(
                                    color: AppColors.primaryDarkColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  tab.icon,
                                  color: AppColors.primaryDarkColor,
                                ),
                              )
                            : Icon(
                                tab.icon,
                                color: AppColors.blackColor.withAlpha(150),
                              ),
                        label: tab.label,
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
