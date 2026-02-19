import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/admin_home/presentation/view/admin_home_screen.dart';
import 'package:sales_tracker/features/home/presentation/view/home_screen.dart';

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
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        Future.microtask(() {
          final s = S.of(context)!;
          context.read<MainLayoutCubit>().setTabs([
            TabItemModel(
              label: s.home,
              icon: IconlyBroken.home,
              page: HomeScreen(),
            ),
            TabItemModel(
              label: s.services,
              icon: IconlyBroken.category,
              page: AdminHomeScreen(),
            ),
            TabItemModel(
              label: s.profile,
              icon: IconlyBroken.work,
              page: const SizedBox(),
            ),
          ]);
        });
        return BlocBuilder<MainLayoutCubit, MainLayoutState>(
          builder: (context, state) {
            final cubit = context.read<MainLayoutCubit>();

            if (state.tabs.isEmpty) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;

                cubit.backPressCount++;

                if (cubit.backPressCount == 1 && state.currentIndex != 1) {
                  cubit.goToPage(1, _pageController);
                } else if (cubit.backPressCount == 1 &&
                    state.currentIndex == 1) {
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
                              color: AppColors.thirdColor,
                            ),
                          ),
                        ),
                      ),
                    );
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 10.h,
                  // shape: const OutlineInputBorder(
                  // borderSide: BorderSide(
                  //   color: AppColors.primaryColor,
                  //   width: 0.7,
                  // ),
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(10.r),
                  //   bottomRight: Radius.circular(10.r),
                  // ),
                  // ),
                  // centerTitle: true,
                  // title: Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //   child: Image.asset(
                  //     AppImages.appLogoWhithoutBg,
                  //     width: 50.w,
                  //     fit: BoxFit.fitWidth,
                  //   ),
                  // ),
                ),
                body: PageView(
                  controller: _pageController,
                  onPageChanged: cubit.onPageChanged,
                  children: state.tabs.map((t) => t.page).toList(),
                ),
                bottomNavigationBar: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    // color: AppColors.primaryDarkColor,
                    // border: Border.all(
                    //   color: AppColors.primaryColor,
                    //   width: 0.8,
                    //   strokeAlign: BorderSide.strokeAlignOutside,
                    // ),
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(10.r),
                    //   topRight: Radius.circular(10.r),
                    // ),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: AppColors.whiteColor,
                    useLegacyColorScheme: false,
                    currentIndex: state.currentIndex,
                    onTap: (index) => cubit.goToPage(index, _pageController),
                    selectedItemColor: AppColors.primaryDarkColor,
                    unselectedItemColor: AppColors.blackColor.withAlpha(150),
                    type: BottomNavigationBarType.fixed,
                    items: state.tabs.map((tab) {
                      final isActive =
                          state.tabs.indexOf(tab) == state.currentIndex;
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
